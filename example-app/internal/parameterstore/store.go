package parameterstore

type Store interface {
	GetParameterValue(name string) (string, error)
}
