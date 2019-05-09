package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ssm"

	"github.com/gin-gonic/gin"

	dataRouter "example-app/internal/router/data"
	dataService "example-app/internal/service/data"
	dataStore "example-app/internal/store/data"

	healthRouter "example-app/internal/router/health"
	"example-app/internal/store/parameter"
)

const (
	MODE  string = "MODE"
	LOCAL string = "LOCAL"

	ENV_DB_USERNAME_PARAM = "DB_USERNAME_PARAM"
	ENV_DB_PASSWORD_PARAM = "DB_PASSWORD_PARAM"
	ENV_DB_ENDPOINT       = "DB_ENDPOINT"
	ENV_DB_NAME           = "DB_NAME"
)

func main() {
	dataStore, err := getDataStore()
	if err != nil {
		fmt.Println(err.Error())
	}
	dataService, err := getDataService(dataStore)
	if err != nil {
		fmt.Println(err.Error())
	}

	router := gin.Default()
	healthRouter.Handle(router)
	dataRouter.Handle(dataService, router)
	router.Run(":8080") // todo: pass as env var
}

func getDataStore() (dataStore.Store, error) {
	endpoint := os.Getenv(ENV_DB_ENDPOINT)
	databaseName := os.Getenv(ENV_DB_NAME)

	var err error
	var username, password string
	switch mode := os.Getenv(MODE); mode {
	case LOCAL:
		username, password, err = getCredentialsFromEnvVars()
	default:
		username, password, err = getCredentialsFromSSM()
	}

	if err != nil {
		return nil, err
	}
	return dataStore.NewSQLStore(username, password, endpoint, databaseName)
}

func getDataService(store dataStore.Store) (dataService.Service, error) {
	return dataService.StandardService{
		DataStore: store,
	}, nil
}

func getCredentialsFromSSM() (string, string, error) {
	awsSession := session.Must(session.NewSession(aws.NewConfig()))
	parmStore := &parameter.SSMStore{
		Client: ssm.New(awsSession),
	}
	username, err := parmStore.GetParameterValue(os.Getenv(ENV_DB_USERNAME_PARAM))
	if err != nil {
		return "", "", err
	}
	password, err := parmStore.GetParameterValue(os.Getenv(ENV_DB_PASSWORD_PARAM))
	if err != nil {
		return "", "", err
	}
	return username, password, err
}

func getCredentialsFromEnvVars() (string, string, error) {
	username := os.Getenv(ENV_DB_USERNAME_PARAM)
	password := os.Getenv(ENV_DB_PASSWORD_PARAM)
	return username, password, nil
}
