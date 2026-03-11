#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const currentFilePath = fileURLToPath(import.meta.url);
const rootDir = path.resolve(path.dirname(currentFilePath), "..");
const jsonPath = path.join(rootDir, "mock", "affinity-profiles.mock.json");
const utsPath = path.join(rootDir, "mock", "affinity-profiles.mock.uts");

const raw = fs.readFileSync(jsonPath, "utf8");
const parsed = JSON.parse(raw);

if (!Array.isArray(parsed) || parsed.length < 3) {
  throw new Error("affinity-profiles.mock.json must be an array with at least 3 entries");
}

const banner = [
  "// AUTO-GENERATED FILE. DO NOT EDIT DIRECTLY.",
  "// Source: mock/affinity-profiles.mock.json",
  ""
].join("\n");

const output = `${banner}\nexport const AFFINITY_PROFILES_MOCK = ${JSON.stringify(parsed, null, 2)}\n`;
fs.writeFileSync(utsPath, output, "utf8");
console.log(`Generated ${path.relative(rootDir, utsPath)} from ${path.relative(rootDir, jsonPath)}`);
