package data

type Store interface {
	Get(string) (string, error)
}
