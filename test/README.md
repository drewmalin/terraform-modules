It is necessary to create two secret SSM parameters prior to deployment:

"<namespace>/db_user"
"<namespace>/db_pass"

```
> aws ssm put-parameter --name "/dmtest/db_user" --value "mysupersecretuser" --type "SecureString"

...

> aws ssm put-parameter --name "/dmtest/db_pass" --value "mysupersecretpass" --type "SecureString"
```