'use client';
import React from 'react';
import { CandyButton } from '../ui/CandyButton';
import { useSimulator } from '../providers/SimulatorProvider';

export function Footer() {
  const { openSimulator } = useSimulator();

  return (
    <footer className="w-full bg-ink pt-32 pb-12 px-6 relative overflow-hidden">
      <div className="absolute top-0 left-0 w-full h-8 bg-mustard border-b-3 border-ink" />
      
      <div className="max-w-7xl mx-auto flex flex-col items-center text-center">
        <h2 className="font-display font-extrabold text-[52px] lg:text-[86px] leading-[0.9] tracking-tight text-cream mb-12">
          Stop waiting.<br/>Start trading.
        </h2>
        
        <CandyButton onClick={() => openSimulator('dashboard')} variant="primary" size="lg" className="mb-24 scale-110">
          Try the Simulator Now
        </CandyButton>

        <div className="w-full flex flex-col md:flex-row justify-between items-center border-t-3 border-cream/20 pt-8">
          <div className="flex items-center gap-3 mb-6 md:mb-0">
            <div className="w-8 h-8 bg-mustard rounded-[8px] border-[2px] border-cream flex items-center justify-center">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--color-ink)" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M4 12c4-8 4-8 8 0s4 8 8 0" /></svg>
            </div>
            <span className="font-display font-extrabold text-xl tracking-tight text-cream">ClearSwap</span>
          </div>

          <div className="font-sans text-cream/70 text-sm">
            Interactive Web Simulation — iOS Native App Coming Soon.
          </div>
        </div>
      </div>
    </footer>
  );
}
