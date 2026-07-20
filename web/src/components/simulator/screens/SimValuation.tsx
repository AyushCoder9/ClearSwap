import React from 'react';
import { motion } from 'framer-motion';
import { useSimulator } from '../../providers/SimulatorProvider';

export function SimValuation() {
  const { navigate } = useSimulator();

  return (
    <motion.div 
      initial={{ x: '100%', opacity: 0 }}
      animate={{ x: 0, opacity: 1 }}
      exit={{ x: '-100%', opacity: 0 }}
      transition={{ type: 'spring', bounce: 0, duration: 0.4 }}
      className="w-full h-full pt-16 px-5 pb-8 overflow-y-auto bg-black text-white flex flex-col relative"
    >
      <div className="absolute top-0 right-0 w-64 h-64 bg-emerald-500/10 rounded-full blur-[80px] pointer-events-none" />

      <div className="flex items-center gap-3 mb-8 cursor-pointer relative z-10" onClick={() => navigate('dashboard')}>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
        <h1 className="font-display font-semibold text-xl tracking-tight text-white/80">Valuation Studio</h1>
      </div>

      <div className="flex-1 relative z-10">
        <h2 className="font-sans font-medium text-[28px] leading-tight mb-1">iPhone 15 Pro</h2>
        <p className="font-sans text-white/50 text-[15px] mb-10">Fair Market Value: <span className="text-emerald-400 font-semibold">₹89,000</span></p>

        {/* Premium Dark Chart */}
        <div className="relative w-full h-56 bg-white/5 backdrop-blur-xl border border-white/10 rounded-[28px] mb-8 p-5 flex items-end justify-between overflow-hidden">
          {/* Subtle Grid */}
          <div className="absolute inset-0 opacity-10" style={{ backgroundImage: 'linear-gradient(to right, rgba(255,255,255,0.1) 1px, transparent 1px), linear-gradient(to bottom, rgba(255,255,255,0.1) 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
          
          {[40, 65, 90, 100, 85, 50, 30].map((h, i) => (
            <div key={i} className="relative z-10 w-8 bg-white/10 border-t border-white/20 rounded-t-lg transition-all" style={{ height: `${h}%` }} />
          ))}
          
          {/* Neon indicator line */}
          <div className="absolute top-0 bottom-0 left-[45%] w-[1.5px] bg-emerald-400 shadow-[0_0_15px_rgba(52,211,153,1)] z-20" />
          <div className="absolute top-4 left-[28%] bg-black/60 backdrop-blur-md border border-white/10 font-semibold text-[10px] uppercase tracking-widest text-emerald-400 px-3 py-1.5 rounded-full z-20 shadow-lg">
            Mint Cond.
          </div>
        </div>

        <div className="space-y-3">
          <div className="flex justify-between items-center p-4 bg-white/5 backdrop-blur-xl border border-white/10 rounded-[20px]">
            <span className="font-sans text-white/70">Lock Price</span>
            <span className="font-display font-semibold text-emerald-400 text-lg">₹89,000</span>
          </div>
        </div>
      </div>

      {/* Bottom CTA */}
      <div className="absolute bottom-12 left-0 right-0 px-6 z-20">
        <button 
          onClick={() => navigate('dashboard')}
          className="w-full bg-[#2ECC71] text-black font-bold py-4 rounded-full text-[17px] active:opacity-80 transition-opacity shadow-[0_0_20px_rgba(46,204,113,0.3)] pointer-events-auto"
        >
          Proceed to Escrow
        </button>
      </div>
    </motion.div>
  );
}
