// ESLint v9 flat config. Picked up automatically by the VS Code ESLint
// extension and the `task lint` target.
import js from "@eslint/js";
import tseslint from "typescript-eslint";

export default [
  {
    ignores: [
      "node_modules/",
      "dist/",
      "build/",
      ".venv/",
      "src/courses/**/student_template_project/",
    ],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
      "no-console": "off",
    },
  },
];
