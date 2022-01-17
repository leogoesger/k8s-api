package handlers

import (
	"context"
	"log"
	"net/http"

	"github.com/leogoesger/test-k8s/foundation/web"
)

type check struct {
	log   *log.Logger
	build string
}

func NewCheckAPI(log *log.Logger, build string) *check {
	return &check{log, build}
}

func (c *check) health(ctx context.Context, w http.ResponseWriter, r *http.Request) error {
	status := "okdokie"
	statusCode := http.StatusOK

	health := struct {
		Version string `json:"version"`
		Status  string `json:"status"`
	}{
		Version: c.build,
		Status:  status,
	}
	return web.Respond(ctx, w, health, statusCode)
}
