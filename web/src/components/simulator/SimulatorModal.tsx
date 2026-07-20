'use client';

import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useSimulator } from '../providers/SimulatorProvider';
import { SimOnboarding } from './screens/SimOnboarding';
import { SimScanItem } from './screens/SimScanItem';
import { SimDashboard } from './screens/SimDashboard';
import { SimValuation } from './screens/SimValuation';
import { SimRadar } from './screens/SimRadar';
import { SimTerminal } from './screens/SimTerminal';
import { SimWallet } from './screens/SimWallet';

export function SimulatorModal() {
  const { isOpen, closeSimulator, currentScreen } = useSimulator();

  if (!isOpen) return null;

  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 z-[100] flex items-center justify-center bg-ink/80 backdrop-blur-sm p-4 sm:p-8"
      >
        <div className="absolute inset-0" onClick={closeSimulator} />
        
        {/* Device Frame */}
        <motion.div
          initial={{ scale: 0.9, y: 20 }}
          animate={{ scale: 1, y: 0 }}
          exit={{ scale: 0.9, y: 20 }}
          transition={{ type: "spring", bounce: 0.25, duration: 0.5 }}
          className="relative w-[375px] h-[812px] bg-black rounded-[55px] border-[14px] border-black shadow-[0_20px_50px_rgba(0,0,0,0.5),inset_0_0_0_1px_rgba(255,255,255,0.1)] overflow-hidden z-10 flex flex-col"
        >
          {/* Dynamic Island Notch */}
          <div className="absolute top-2 left-1/2 -translate-x-1/2 w-[120px] h-[35px] bg-black rounded-full z-50 shadow-[0_0_10px_rgba(0,0,0,0.5)] border border-white/5" />

          {/* Screen Content Router */}
          <div className="relative flex-1 bg-black w-full h-full overflow-hidden">
            <AnimatePresence mode="wait">
              {currentScreen === 'onboarding' && <SimOnboarding key="onboarding" />}
              {currentScreen === 'scan-item' && <SimScanItem key="scan-item" />}
              {currentScreen === 'dashboard' && <SimDashboard key="dashboard" />}
              {currentScreen === 'valuation' && <SimValuation key="valuation" />}
              {currentScreen === 'radar' && <SimRadar key="radar" />}
              {currentScreen === 'terminal' && <SimTerminal key="terminal" />}
              {currentScreen === 'wallet' && <SimWallet key="wallet" />}
            </AnimatePresence>
          </div>

          {/* Home Indicator */}
          <div className="absolute bottom-2 left-1/2 -translate-x-1/2 w-1/3 h-1.5 bg-white/50 rounded-full z-50" />
        </motion.div>
        
        {/* Close Button */}
        <button 
          onClick={closeSimulator}
          className="absolute top-6 right-6 md:top-8 md:right-8 w-12 h-12 bg-white rounded-full border-memphis shadow-memphis flex items-center justify-center hover-memphis z-50"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--color-ink)" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </motion.div>
    </AnimatePresence>
  );
}
