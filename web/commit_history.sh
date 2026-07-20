#!/bin/bash

# Initialize new repo
git init
git branch -M main

# First commit - Config files
git add package.json package-lock.json tsconfig.json postcss.config.mjs tailwind.config.ts next.config.mjs vercel.json
git commit -m "chore: initial project configuration and dependencies"

# Second commit - Core styles and layout
git add src/app/globals.css src/app/layout.tsx
git commit -m "feat: implement memphis design system global styles and layout"

# Third commit - UI Components - Buttons
git add src/components/ui/CandyButton.tsx
git commit -m "feat(ui): add CandyButton component for primary actions"

# Fourth commit - UI Components - Decorative
git add src/components/ui/ConfettiShape.tsx src/components/ui/MarkerHighlight.tsx
git commit -m "feat(ui): add playful memphis decorative components"

# Fifth commit - UI Components - Mockup
git add src/components/ui/AppMockup.tsx
git commit -m "feat(ui): add iOS app mockup container component"

# Sixth commit - Simulator Provider
git add src/components/providers/SimulatorProvider.tsx
git commit -m "feat(simulator): add global context provider for simulator state"

# Seventh commit - Simulator UI Shell
git add src/components/simulator/SimulatorUI.tsx
git commit -m "feat(simulator): implement interactive iOS device shell"

# Eighth commit - Simulator Screens 1
git add src/components/simulator/screens/DashboardScreen.tsx src/components/simulator/screens/ValuationScreen.tsx
git commit -m "feat(simulator): build dashboard and valuation screens"

# Ninth commit - Simulator Screens 2
git add src/components/simulator/screens/RadarScreen.tsx src/components/simulator/screens/TerminalScreen.tsx src/components/simulator/screens/SuccessScreen.tsx
git commit -m "feat(simulator): build radar, pos terminal, and success screens"

# Tenth commit - Home Page Shell
git add src/app/page.tsx
git commit -m "feat(home): build responsive landing page structure and hero section"

# Eleventh commit - Sections - How it works
git add src/components/sections/HowItWorks.tsx
git commit -m "feat(home): implement How It Works scrollable timeline section"

# Twelfth commit - Sections - FAQ
git add src/components/sections/FAQ.tsx
git commit -m "feat(home): implement interactive FAQ accordion"

# Thirteenth commit - Sections - Footer
git add src/components/sections/Footer.tsx
git commit -m "feat(home): add bold typographic footer"

# Fourteenth commit - Testing Config
git add jest.config.ts jest.setup.ts playwright.config.ts
git commit -m "test: configure jest and playwright for ui and e2e testing"

# Fifteenth commit - Tests
git add tests/
git commit -m "test: add simulator provider unit tests and happy path e2e flow"

# Add remaining files
git add .
git commit -m "chore: finalize remaining components and clean up"

echo "Done creating 16 modular atomic commits!"
