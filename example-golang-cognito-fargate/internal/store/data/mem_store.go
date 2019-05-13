package data

import "errors"

type MemoryStore struct {
	db map[string]string
}

func NewMemoryStore() (*MemoryStore, error) {
	db := make(map[string]string)
	return &MemoryStore{db}, nil
}

func (s *MemoryStore) Get(key string) (string, error) {
	data, ok := s.db[key]
	if !ok {
		return "", errors.New(":(")
	}
	return data, nil
}
