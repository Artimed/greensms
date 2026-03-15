-- GreenSMS Pro — Supabase schema
-- Run in Supabase SQL editor

CREATE TABLE IF NOT EXISTS licenses (
  key           TEXT PRIMARY KEY,
  device_id     TEXT,
  expires_at    TIMESTAMPTZ NOT NULL,
  status        TEXT NOT NULL DEFAULT 'active',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_licenses_device_id ON licenses (device_id);

CREATE TABLE IF NOT EXISTS device_tokens (
  device_id   TEXT PRIMARY KEY,
  fcm_token   TEXT NOT NULL,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS parser_versions (
  version      INTEGER PRIMARY KEY,
  url          TEXT NOT NULL,
  released_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_current   BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_parser_versions_current
  ON parser_versions (is_current) WHERE is_current = TRUE;

ALTER TABLE licenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE device_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE parser_versions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_read_parser_versions"
  ON parser_versions FOR SELECT TO anon USING (TRUE);
