package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"

	dataRouter "example-app/internal/router/data"
	dataService "example-app/internal/service/data"
	dataStore "example-app/internal/store/data"

	healthRouter "example-app/internal/router/health"
)

const (
	ENV_LOCAL string = "LOCAL"
	ENV_MODE  string = "MODE"
	ENV_PORT  string = "PORT"
)

func main() {
	dataStore, err := dataStore.NewMemoryStore()
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
	router.Run(os.Getenv(ENV_PORT))
}

func getDataService(store dataStore.Store) (dataService.Service, error) {
	return dataService.StandardService{
		DataStore: store,
	}, nil
}