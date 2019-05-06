package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ssm"

	"github.com/gin-gonic/gin"

	"example-app/internal/datastore"
	"example-app/internal/parameterstore"
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
	fmt.Println(os.Environ())
	dataStore, err := getDataStore()
	if err != nil {
		fmt.Println(err.Error())
	}

	router := gin.Default()
	router.GET("/query", func(c *gin.Context) {
		result, err := dataStore.Query("SELECT 1 as result;")
		if err != nil {
			failure(500, err.Error(), c)
		} else {
			success(200, string(result[0].Result), c)
		}
	})
	router.GET("/", func(c *gin.Context) {
		success(200, "success", c)
	})

	router.Run(":8080")
}

func success(status int, message string, c *gin.Context) {
	c.JSON(status, gin.H{
		"message": message,
	})
}

func failure(status int, message string, c *gin.Context) {
	c.JSON(status, gin.H{
		"error": message,
	})
}

func getDataStore() (datastore.Store, error) {
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
	return datastore.NewSQLStore(username, password, endpoint, databaseName)
}

func getCredentialsFromSSM() (string, string, error) {
	awsSession := session.Must(session.NewSession(aws.NewConfig()))
	parmStore := &parameterstore.SSMStore{
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
