module github.com/fabmation-gmbh/helm-whatup

go 1.13

require (
	github.com/Masterminds/semver/v3 v3.0.2
	github.com/fatih/color v1.7.0 // indirect
	github.com/gosuri/uitable v0.0.4
	github.com/konsorten/go-windows-terminal-sequences v1.0.2 // indirect
	github.com/mattn/go-colorable v0.1.4 // indirect
	github.com/mattn/go-isatty v0.0.10 // indirect
	github.com/mattn/go-runewidth v0.0.7 // indirect
	github.com/pkg/errors v0.8.1
	github.com/spf13/cobra v0.0.5
	github.com/tidwall/gjson v1.3.5
	github.com/tidwall/sjson v1.0.4
	golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e // indirect
	gopkg.in/yaml.v2 v2.2.5 // indirect
	helm.sh/helm/v3 v3.0.1
	k8s.io/client-go v0.0.0-20191016111102-bec269661e48
)

replace github.com/docker/docker => github.com/docker/docker v0.0.0-20190731150326-928381b2215c
