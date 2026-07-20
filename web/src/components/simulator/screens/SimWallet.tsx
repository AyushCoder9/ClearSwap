import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { useSimulator } from '../../providers/SimulatorProvider';

export function SimWallet() {
  const { closeSimulator } = useSimulator();
  const [showConfetti, setShowConfetti] = useState(false);

  useEffect(() => {
    setShowConfetti(true);
  }, []);

  return (
    <motion.div 
      initial={{ y: '100%', opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      exit={{ y: '100%', opacity: 0 }}
      transition={{ type: 'spring', bounce: 0.2, duration: 0.6 }}
      className="w-full h-full pt-16 px-5 pb-8 overflow-y-auto bg-black flex flex-col items-center relative text-white"
    >
      <div className="absolute top-0 right-0 w-64 h-64 bg-emerald-500/10 rounded-full blur-[80px] pointer-events-none" />

      {/* Floating particles (instead of confetti for a premium feel) */}
      {showConfetti && (
        <div className="absolute inset-0 pointer-events-none z-0 overflow-hidden">
           <div className="absolute w-2 h-2 bg-emerald-400 rounded-full top-[20%] left-[20%] animate-bounce shadow-[0_0_10px_rgba(52,211,153,1)]" />
           <div className="absolute w-1.5 h-1.5 bg-blue-400 rounded-full top-[40%] right-[15%] animate-ping" style={{ animationDuration: '3s' }} />
           <div className="absolute w-2.5 h-2.5 bg-purple-400 rounded-full bottom-[40%] left-[15%] animate-pulse shadow-[0_0_10px_rgba(192,132,252,1)]" />
        </div>
      )}

      <div className="w-16 h-16 bg-emerald-500/20 rounded-full border border-emerald-500/50 flex items-center justify-center mb-6 z-10 shadow-[0_0_30px_rgba(52,211,153,0.3)]">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="rgb(52,211,153)" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
      </div>

      <h1 className="font-display font-semibold text-[22px] text-white mb-10 z-10">Payment Confirmed</h1>

      {/* Apple Wallet Pass Mockup - Premium Gold/Dark Metal */}
      <motion.div 
        initial={{ scale: 0.8, y: 50 }}
        animate={{ scale: 1, y: 0 }}
        transition={{ delay: 0.3, type: 'spring' }}
        className="w-full bg-gradient-to-b from-[#2a2a2a] to-[#111111] rounded-[28px] border border-white/10 p-1 z-10 relative overflow-hidden shadow-[0_20px_40px_rgba(0,0,0,0.8)]"
      >
        <div className="absolute top-0 left-0 w-full h-24 bg-gradient-to-r from-amber-500/20 to-orange-400/20 border-b border-white/5 flex items-center justify-center">
          <div className="absolute inset-0 bg-white/5 backdrop-blur-3xl" />
          <span className="relative z-10 font-sans font-medium text-amber-500/90 text-sm tracking-[0.3em] uppercase">Verified Receipt</span>
        </div>
        
        <div className="pt-28 pb-6 px-6">
          <div className="flex justify-between items-end border-b border-white/10 pb-4 mb-4">
            <div>
              <p className="font-sans text-[11px] text-white/40 uppercase tracking-wider font-semibold mb-1">Item</p>
              <p className="font-sans font-medium text-white/90">iPhone 15 Pro, 256GB</p>
            </div>
          </div>
          
          <div className="flex justify-between items-end border-b border-white/10 pb-4 mb-6">
            <div>
              <p className="font-sans text-[11px] text-white/40 uppercase tracking-wider font-semibold mb-1">Serial No.</p>
              <p className="font-sans font-medium text-white/90 font-mono text-sm">G9G0K2L5P1</p>
            </div>
          </div>

          <div className="flex justify-between items-end">
            <div>
              <p className="font-sans text-[11px] text-white/40 uppercase tracking-wider font-semibold mb-1">Price</p>
              <p className="font-display font-semibold text-2xl text-emerald-400">₹89,000</p>
            </div>
            <div className="w-10 h-10 bg-white/5 rounded-full flex items-center justify-center border border-white/10">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 12V7H5a2 2 0 0 1 0-4h14v4" /><path d="M3 5v14a2 2 0 0 0 2 2h16v-5" /><path d="M18 12a2 2 0 0 0 0 4h4v-4Z" /></svg>
            </div>
          </div>
        </div>
      </motion.div>

      <button 
        onClick={closeSimulator} 
        className="w-full mt-auto z-10 bg-white/10 backdrop-blur-md border border-white/10 text-white font-semibold text-[15px] py-4 rounded-full transition-transform active:scale-95"
      >
        Done
      </button>
    </motion.div>
  );
}
