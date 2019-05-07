package data

import (
	"github.com/gin-gonic/gin"

	dataService "example-app/internal/service/data"
)

func Handle(service dataService.Service, router *gin.Engine) {
	router.GET("/query", func(c *gin.Context) {
		result, err := service.Get()
		if err != nil {
			failure(500, err.Error(), c)
		} else {
			success(200, string(result.Result), c)
		}
	})
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
