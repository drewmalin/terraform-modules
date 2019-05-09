package data

import (
	dataStore "example-app/internal/store/data"
)

type Service interface {
	Get() (dataStore.Data, error)
}

type StandardService struct {
	DataStore dataStore.Store
}

func (s StandardService) Get() (dataStore.Data, error) {
	result, err := s.DataStore.Get()
	return result[0], err
}
