module github.com/fabmation-gmbh/helm-whatup

go 1.13

require (
	github.com/Masterminds/semver/v3 v3.0.2
	github.com/fatih/color v1.7.0 // indirect
	github.com/gosuri/uitable v0.0.4
	github.com/mattn/go-colorable v0.1.4 // indirect
	github.com/mattn/go-isatty v0.0.10 // indirect
	github.com/mattn/go-runewidth v0.0.7 // indirect
	github.com/pkg/errors v0.8.1
	github.com/spf13/cobra v0.0.5
	github.com/tidwall/gjson v1.3.5
	github.com/tidwall/sjson v1.0.4
	helm.sh/helm/v3 v3.0.0
)

replace github.com/docker/docker => github.com/docker/docker v0.0.0-20190731150326-928381b2215c
