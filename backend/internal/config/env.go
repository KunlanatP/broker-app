package config

import (
	"fmt"
	"os"

	"github.com/joho/godotenv"
)

type Env struct {
	AppName    string
	AppPort    string
	DBHost     string
	DBPort     string
	DBUser     string
	DBPassword string
	DBName     string
	DBSSLMode  string
	DBTimeZone string
}

func LoadEnv() Env {
	_ = godotenv.Load()

	return Env{
		AppName:    getEnv("APP_NAME", "broker-api"),
		AppPort:    getEnv("APP_PORT", "8080"),
		DBHost:     getEnv("DB_HOST", "localhost"),
		DBPort:     getEnv("DB_PORT", "5432"),
		DBUser:     getEnv("DB_USER", "postgres"),
		DBPassword: getEnv("DB_PASSWORD", "postgres"),
		DBName:     getEnv("DB_NAME", "broker_db"),
		DBSSLMode:  getEnv("DB_SSLMODE", "disable"),
		DBTimeZone: getEnv("DB_TIMEZONE", "Asia/Bangkok"),
	}
}

func (e Env) DatabaseDSN() string {
	if dsn := os.Getenv("DB_DSN"); dsn != "" {
		return dsn
	}

	return fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s TimeZone=%s",
		e.DBHost,
		e.DBPort,
		e.DBUser,
		e.DBPassword,
		e.DBName,
		e.DBSSLMode,
		e.DBTimeZone,
	)
}

func getEnv(key string, fallback string) string {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}
	return value
}
