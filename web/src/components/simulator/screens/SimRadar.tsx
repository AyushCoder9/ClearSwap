import React from 'react';
import { motion } from 'framer-motion';
import { useSimulator } from '../../providers/SimulatorProvider';

export function SimRadar() {
  const { navigate } = useSimulator();

  return (
    <motion.div 
      initial={{ x: '100%', opacity: 0 }}
      animate={{ x: 0, opacity: 1 }}
      exit={{ x: '-100%', opacity: 0 }}
      transition={{ type: 'spring', bounce: 0, duration: 0.4 }}
      className="w-full h-full bg-black relative overflow-hidden flex flex-col text-white"
    >
      {/* Dark Map Background Simulation */}
      <div className="absolute inset-0 opacity-[0.03]" style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '30px 30px' }} />
      
      <div className="relative z-10 pt-16 px-5 pb-8 flex-1 flex flex-col">
        <div className="flex items-center gap-3 mb-8 cursor-pointer" onClick={() => navigate('valuation')}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
          <h1 className="font-display font-semibold text-xl tracking-tight text-white/80">Meetup Radar</h1>
        </div>

        {/* Glowing Radar Rings */}
        <div className="flex-1 flex items-center justify-center relative">
          <div className="absolute w-72 h-72 border border-emerald-500/20 rounded-full animate-spin-slow" style={{ borderStyle: 'dashed' }} />
          <div className="absolute w-56 h-56 border border-emerald-500/30 rounded-full animate-ping" style={{ animationDuration: '4s' }} />
          <div className="absolute w-36 h-36 border border-emerald-500/40 rounded-full" />
          
          {/* User Center Dot */}
          <div className="absolute w-12 h-12 rounded-full flex items-center justify-center bg-emerald-500/20 border border-emerald-500/30">
            <span className="w-3 h-3 bg-emerald-400 rounded-full shadow-[0_0_15px_rgba(52,211,153,1)]" />
          </div>

          {/* Buyer Dot approaching */}
          <motion.div 
            initial={{ scale: 0, x: 80, y: -80 }}
            animate={{ scale: 1, x: 30, y: -30 }}
            transition={{ delay: 0.5, type: 'spring' }}
            className="absolute z-20 flex items-center justify-center"
          >
            <div className="absolute w-8 h-8 bg-blue-500/20 rounded-full animate-ping" />
            <div className="w-3 h-3 bg-blue-400 rounded-full shadow-[0_0_15px_rgba(96,165,250,1)]" />
          </motion.div>
        </div>

        {/* Glassmorphic Status Card */}
        <div className="bg-white/10 backdrop-blur-xl rounded-[28px] border border-white/20 p-5 mt-auto">
          <div className="flex items-center gap-3 mb-1">
            <div className="w-2.5 h-2.5 bg-emerald-400 rounded-full animate-pulse shadow-[0_0_10px_rgba(52,211,153,1)]" />
            <span className="font-sans font-semibold text-white">Buyer Approaching</span>
          </div>
          <p className="font-sans text-white/50 text-sm mb-6 pl-5.5">ETA: 2 mins • Distance: 150m</p>

          <button 
            onClick={() => navigate('terminal')} 
            className="w-full bg-white text-black font-semibold text-[15px] py-4 rounded-full transition-transform active:scale-95"
          >
            Verify Meetup
          </button>
        </div>
      </div>
    </motion.div>
  );
}
