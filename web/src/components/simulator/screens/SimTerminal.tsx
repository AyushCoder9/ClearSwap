import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useSimulator } from '../../providers/SimulatorProvider';

export function SimTerminal() {
  const { navigate } = useSimulator();
  const [scanning, setScanning] = useState(false);

  const handleScan = () => {
    setScanning(true);
    setTimeout(() => {
      navigate('wallet');
    }, 1500);
  };

  return (
    <motion.div 
      initial={{ x: '100%', opacity: 0 }}
      animate={{ x: 0, opacity: 1 }}
      exit={{ x: '-100%', opacity: 0 }}
      transition={{ type: 'spring', bounce: 0, duration: 0.4 }}
      className="w-full h-full pt-16 px-5 pb-8 overflow-y-auto bg-[#0a0a0a] text-white flex flex-col items-center relative"
    >
      <div className="absolute top-0 right-0 w-64 h-64 bg-emerald-500/5 rounded-full blur-[80px] pointer-events-none" />

      <div className="w-full flex items-center gap-3 mb-16 cursor-pointer relative z-10" onClick={() => navigate('radar')}>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
        <h1 className="font-display font-semibold text-xl tracking-tight text-white/80">POS Terminal</h1>
      </div>

      <div className="relative w-64 h-64 bg-white/5 backdrop-blur-2xl rounded-[36px] border border-white/20 flex items-center justify-center p-6 mb-16 shadow-[0_0_50px_rgba(255,255,255,0.05)] overflow-hidden">
        {/* Fake QR for dark mode (white fill on dark bg) */}
        <div className="w-full h-full bg-[url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InRyYW5zcGFyZW50Ii8+PHBhdGggZD0iTTEwIDEwaDQwdjQwSDEwek0yMCAyMGgyMHYyMEgyMHpNNzAgMTBoNDB2NDBINzB6TTgwIDIwaDIwdjIwSDgwek0xMCA3MGg0MHY0MEgxMHpNMjAgODBoMjB2MjBIMjB6TTEzMCAxMGg0MHY0MEgxMzB6TTE0MCAyMGgyMHYyMEgxNDB6TTEwIDEzMGg0MHY0MEgxMHpNMjAgMTQwaDIwdjIwSDIwek03MCA3MGgyMHYyMEg3MHoiIGZpbGw9IiNmZmZmZmYiLz48L3N2Zz4=')] bg-contain bg-no-repeat bg-center opacity-80" />
        
        {/* Four corner markers */}
        <div className="absolute top-4 left-4 w-6 h-6 border-t-2 border-l-2 border-emerald-400 rounded-tl-lg" />
        <div className="absolute top-4 right-4 w-6 h-6 border-t-2 border-r-2 border-emerald-400 rounded-tr-lg" />
        <div className="absolute bottom-4 left-4 w-6 h-6 border-b-2 border-l-2 border-emerald-400 rounded-bl-lg" />
        <div className="absolute bottom-4 right-4 w-6 h-6 border-b-2 border-r-2 border-emerald-400 rounded-br-lg" />

        {scanning && (
          <motion.div 
            initial={{ top: 0 }}
            animate={{ top: '100%' }}
            transition={{ duration: 1.5, ease: "linear" }}
            className="absolute left-0 right-0 h-[2px] bg-emerald-400 shadow-[0_0_20px_rgba(52,211,153,1)] z-10"
          />
        )}
      </div>

      <div className="bg-white/5 backdrop-blur-xl rounded-[28px] border border-white/10 p-6 w-full text-center mb-8 relative z-10">
        <h2 className="font-sans font-medium text-white/50 text-[13px] uppercase tracking-wider mb-2">Scan to Release</h2>
        <p className="font-display font-semibold text-3xl text-emerald-400 drop-shadow-[0_0_15px_rgba(52,211,153,0.3)]">₹89,000</p>
      </div>

      <button 
        onClick={handleScan} 
        disabled={scanning}
        className={`w-full mt-auto relative z-10 font-semibold text-[15px] py-4 rounded-full transition-transform ${scanning ? 'bg-white/10 text-white/50 cursor-not-allowed' : 'bg-white text-black active:scale-95'}`}
      >
        {scanning ? 'Scanning FaceID...' : 'Simulate Buyer Scan'}
      </button>
    </motion.div>
  );
}
