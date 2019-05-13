package data

import (
	dataStore "example-app/internal/store/data"
)

type Service interface {
	Get(string) (string, error)
}

type StandardService struct {
	DataStore dataStore.Store
}

func (s StandardService) Get(key string) (string, error) {
	result, err := s.DataStore.Get(key)
	return result, err
}
