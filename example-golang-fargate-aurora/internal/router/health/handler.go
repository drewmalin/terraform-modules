package health

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func Handle(router *gin.Engine) {
	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "healthy",
		})
	})
}
