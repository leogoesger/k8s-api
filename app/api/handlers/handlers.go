package handlers

import (
	"log"
	"net/http"
	"os"

	"github.com/leogoesger/test-k8s/foundation/web"
)

func API(build string, shutdown chan os.Signal, log *log.Logger) http.Handler {
	app := web.NewApp(shutdown)

	checkAPI := NewCheckAPI(log, build)

	app.Handle(http.MethodGet, "/v1/health", checkAPI.health)

	return app
}
