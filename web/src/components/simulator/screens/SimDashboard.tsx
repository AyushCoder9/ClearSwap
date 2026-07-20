import React from 'react';
import { motion } from 'framer-motion';
import { useSimulator } from '../../providers/SimulatorProvider';

export function SimDashboard() {
  const { navigate } = useSimulator();

  return (
    <motion.div 
      initial={{ x: '100%', opacity: 0 }}
      animate={{ x: 0, opacity: 1 }}
      exit={{ x: '-100%', opacity: 0 }}
      transition={{ type: 'spring', bounce: 0, duration: 0.4 }}
      className="w-full h-full pt-16 px-5 pb-8 overflow-y-auto bg-black text-white"
    >
      <div className="flex items-center justify-between mb-8">
        <h1 className="font-display font-semibold text-2xl tracking-tight">Dashboard</h1>
        <div className="w-9 h-9 rounded-full overflow-hidden border-[1.5px] border-white/20 bg-emerald-500 shadow-[0_0_15px_rgba(16,185,129,0.3)]">
          <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=Felix&backgroundColor=10b981" alt="avatar" className="w-full h-full object-cover" />
        </div>
      </div>

      <h2 className="font-sans font-medium text-[13px] uppercase text-white/50 tracking-wider mb-4 px-1">Active Deals</h2>

      {/* Glassmorphic Card */}
      <div 
        className="bg-white/10 backdrop-blur-xl rounded-[24px] border border-white/20 p-5 mb-4 relative overflow-hidden flex flex-col gap-5"
      >
        <div className="absolute top-0 right-0 w-32 h-32 bg-emerald-500/20 rounded-full blur-[40px] -translate-y-1/2 translate-x-1/4" />
        
        <div className="relative z-10 flex justify-between items-start">
          <div>
            <h3 className="font-display font-semibold text-[19px] mb-1">iPhone 15 Pro</h3>
            <p className="font-sans text-white/60 text-sm">Lock Value: ₹89,000</p>
          </div>
          <div className="bg-emerald-500/20 text-emerald-400 font-semibold text-[11px] uppercase tracking-wider px-2.5 py-1 rounded-full border border-emerald-500/30">
            Awaiting Escrow
          </div>
        </div>
        <div className="relative z-10 w-full h-1.5 bg-black/40 rounded-full overflow-hidden inset-shadow-sm">
          <div className="w-1/2 h-full bg-gradient-to-r from-emerald-500 to-teal-400 rounded-full shadow-[0_0_10px_rgba(52,211,153,0.8)]" />
        </div>
        
        <button 
          onClick={() => navigate('radar')}
          className="relative z-10 w-full bg-[#2ECC71] text-black font-bold py-3.5 rounded-2xl text-[15px] active:opacity-80 transition-opacity shadow-[0_0_15px_rgba(46,204,113,0.3)]"
        >
          Fund Escrow
        </button>
      </div>

      {/* Completed Deal */}
      <div className="bg-white/5 backdrop-blur-md rounded-[24px] border border-white/10 p-5 opacity-70">
        <div className="flex justify-between items-start">
          <div>
            <h3 className="font-display font-semibold text-[19px] mb-1">AirPods Max</h3>
            <p className="font-sans text-white/50 text-sm">Completed</p>
          </div>
          <div className="bg-white/10 text-white/80 font-semibold text-[11px] uppercase tracking-wider px-2.5 py-1 rounded-full border border-white/10">
            Done
          </div>
        </div>
      </div>
    </motion.div>
  );
}
