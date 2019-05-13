package parameter

type Store interface {
	GetParameterValue(name string) (string, error)
}
