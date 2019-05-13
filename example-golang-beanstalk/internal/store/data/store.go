package data

type Data struct {
	Result int `db:"result"`
}

type Store interface {
	Get() ([]Data, error)
}
