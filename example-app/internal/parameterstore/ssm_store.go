package parameterstore

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ssm"
)

type SSMStore struct {
	Client *ssm.SSM
}

func (s *SSMStore) GetParameterValue(name string) (string, error) {
	parameter, err := s.Client.GetParameter(&ssm.GetParameterInput{
		Name:           aws.String(name),
		WithDecryption: aws.Bool(true),
	})
	if err != nil {
		return "", err
	}
	return *parameter.Parameter.Value, nil
}
