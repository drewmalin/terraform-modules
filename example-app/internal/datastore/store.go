package datastore

type QueryResult struct {
	Result int `db:"result"`
}

type Store interface {
	Query(name string) ([]QueryResult, error)
}
