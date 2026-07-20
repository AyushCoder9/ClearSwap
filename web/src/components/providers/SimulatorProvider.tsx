'use client';
import React, { createContext, useContext, useState } from 'react';

type Screen = 'onboarding' | 'scan-item' | 'dashboard' | 'valuation' | 'radar' | 'terminal' | 'wallet';

interface SimulatorContextType {
  isOpen: boolean;
  openSimulator: (screen?: Screen) => void;
  closeSimulator: () => void;
  currentScreen: Screen;
  navigate: (screen: Screen) => void;
}

const SimulatorContext = createContext<SimulatorContextType | undefined>(undefined);

export function SimulatorProvider({ children }: { children: React.ReactNode }) {
  const [isOpen, setIsOpen] = useState(false);
  const [currentScreen, setCurrentScreen] = useState<Screen>('onboarding');

  const openSimulator = (screen: Screen = 'onboarding') => {
    setCurrentScreen(screen);
    setIsOpen(true);
    // Prevent scrolling on body when modal is open
    if (typeof window !== 'undefined') {
      document.body.style.overflow = 'hidden';
    }
  };

  const closeSimulator = () => {
    setIsOpen(false);
    if (typeof window !== 'undefined') {
      document.body.style.overflow = 'unset';
    }
  };

  const navigate = (screen: Screen) => {
    setCurrentScreen(screen);
  };

  return (
    <SimulatorContext.Provider value={{ isOpen, openSimulator, closeSimulator, currentScreen, navigate }}>
      {children}
    </SimulatorContext.Provider>
  );
}

export function useSimulator() {
  const context = useContext(SimulatorContext);
  if (context === undefined) {
    throw new Error('useSimulator must be used within a SimulatorProvider');
  }
  return context;
}
