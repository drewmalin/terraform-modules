package data

import (
	"fmt"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

type SQLStore struct {
	db *sqlx.DB
}

func NewSQLStore(username, password, endpoint, databaseName string) (*SQLStore, error) {
	dbSourceFormat := "%s:%s@tcp(%s)/%s?parseTime=true&loc=Local"
	dbSource := fmt.Sprintf(dbSourceFormat, username, password, endpoint, databaseName)

	fmt.Println(dbSource)

	db, err := sqlx.Open("mysql", dbSource)
	if err != nil {
		return nil, err
	}
	return &SQLStore{db}, nil
}

func (s *SQLStore) Get() ([]Data, error) {
	result := []Data{}
	err := s.db.Select(&result, "SELECT 1 as result;")
	return result, err
}
