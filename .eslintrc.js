module.exports = {
  env: {
    node: true,
    es2021: true,
    jest: true,
  },
  extends: ['airbnb-base'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    'no-console': 'warn',
    'no-unused-vars': ['error', { argsIgnorePattern: 'next' }],
    'import/no-extraneous-dependencies': ['error', { devDependencies: ['**/*.test.js', '**/__tests__/**'] }],
    'consistent-return': 'off',
    'no-process-exit': 'off',
  },
};