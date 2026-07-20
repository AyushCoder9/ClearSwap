'use client';
import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { useSimulator } from '../../providers/SimulatorProvider';

export function SimScanItem() {
  const { navigate } = useSimulator();
  const [scanning, setScanning] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => {
      setScanning(false);
    }, 2500);
    return () => clearTimeout(timer);
  }, []);

  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="w-full h-full bg-[#0a0a0a] text-white relative flex flex-col"
    >
      {/* Header */}
      <div className="pt-14 pb-4 px-6 text-center relative z-10">
        <h2 className="text-[20px] font-bold">Scan Product</h2>
        <p className="text-white/60 text-[14px]">Align the serial or barcode</p>
      </div>

      {/* Camera Viewport Mock */}
      <div className="flex-1 relative flex items-center justify-center overflow-hidden">
        {/* Mock background representing a desk/product (just a dark gradient for now) */}
        <div className="absolute inset-0 bg-gradient-to-b from-[#1a1a24] to-[#0d0d12]" />

        {/* Scan Frame */}
        <div className="relative w-64 h-64 border-2 border-white/20 rounded-2xl z-10 flex items-center justify-center">
          {/* Corner accents */}
          <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-[#2ECC71] rounded-tl-2xl" />
          <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-[#2ECC71] rounded-tr-2xl" />
          <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-[#2ECC71] rounded-bl-2xl" />
          <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-[#2ECC71] rounded-br-2xl" />
          
          {/* Scanning Laser */}
          {scanning && (
            <motion.div 
              initial={{ top: 0, opacity: 0 }}
              animate={{ top: ['0%', '100%', '0%'], opacity: [0, 1, 0] }}
              transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
              className="absolute left-0 right-0 h-1 bg-[#2ECC71] shadow-[0_0_15px_#2ECC71]"
            />
          )}

          {/* Success Check */}
          {!scanning && (
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              className="w-16 h-16 bg-[#2ECC71] rounded-full flex items-center justify-center text-black shadow-[0_0_30px_rgba(46,204,113,0.5)]"
            >
              <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M20 6L9 17l-5-5"/></svg>
            </motion.div>
          )}
        </div>
      </div>

      {/* Bottom Panel */}
      <motion.div 
        className="bg-[#151515] rounded-t-3xl p-6 relative z-10 border-t border-white/10"
        animate={{ y: scanning ? 0 : 0 }}
      >
        <div className="w-12 h-1 bg-white/20 rounded-full mx-auto mb-6" />
        
        {scanning ? (
          <div className="text-center py-4">
            <div className="w-8 h-8 border-2 border-[#2ECC71] border-t-transparent rounded-full animate-spin mx-auto mb-3" />
            <p className="text-white/60 font-medium">Looking for product details...</p>
          </div>
        ) : (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="flex flex-col gap-4">
            <div className="flex items-center gap-4 bg-white/5 p-4 rounded-2xl border border-white/10">
              <div className="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></svg>
              </div>
              <div>
                <h3 className="font-bold text-[16px]">iPhone 15 Pro</h3>
                <p className="text-white/50 text-[13px]">Serial: G9G0K2L5P1 • 256GB</p>
              </div>
            </div>
            
            <button 
              onClick={() => navigate('valuation')}
              className="w-full bg-[#2ECC71] text-black py-4 rounded-2xl font-bold text-[16px] transition-transform active:scale-[0.98]"
            >
              Get Market Valuation
            </button>
          </motion.div>
        )}
      </motion.div>
    </motion.div>
  );
}
