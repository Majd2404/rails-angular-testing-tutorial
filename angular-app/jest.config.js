// jest.config.js
module.exports = {
  preset: 'jest-preset-angular',
  setupFilesAfterFramework: ['<rootDir>/setup-jest.ts'],
  testPathPattern: '.*\\.spec\\.ts$',
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.module.ts',
    '!src/main.ts',
    '!src/environments/**'
  ],
  coverageReporters: ['text', 'lcov', 'html'],
  coverageThresholds: {
    global: {
      branches:   80,
      functions:  80,
      lines:      80,
      statements: 80,
    }
  }
};
