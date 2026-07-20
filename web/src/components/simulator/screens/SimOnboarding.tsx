'use client';
import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useSimulator } from '../../providers/SimulatorProvider';

const slides = [
  {
    id: 1,
    title: 'Market Intelligence',
    subtitle: 'KNOW YOUR PRICE',
    desc: "Stop guessing. ClearSwap's real-time bell curve shows exactly what your item is worth across conditions.",
    badge: 'Swift Charts',
    icon: (
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M3 3v18h18"/><path d="M18 9l-5 5-4-4-6 6"/>
      </svg>
    ),
    color: '#2ECC71'
  },
  {
    id: 2,
    title: 'Escrow Security',
    subtitle: 'ZERO TRUST REQUIRED',
    desc: 'Funds are locked in escrow before you meet. Watch the meetup approach live on your Lock Screen.',
    badge: 'ActivityKit',
    icon: (
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M9 12l2 2 4-4"/>
      </svg>
    ),
    color: '#3498DB'
  },
  {
    id: 3,
    title: 'Apple Wallet Receipt',
    subtitle: 'PROOF OF OWNERSHIP',
    desc: 'The moment payment is confirmed, a signed Verified Receipt lands in your Apple Wallet.',
    badge: 'PassKit',
    icon: (
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
        <rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/>
      </svg>
    ),
    color: '#F1C40F'
  }
];

export function SimOnboarding() {
  const { navigate } = useSimulator();
  const [currentSlide, setCurrentSlide] = useState(0);

  const nextSlide = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(s => s + 1);
    } else {
      navigate('scan-item');
    }
  };

  const slide = slides[currentSlide];

  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="w-full h-full text-white relative overflow-hidden"
      style={{
        background: `linear-gradient(135deg, #0F141A 0%, ${slide.color}15 100%)`
      }}
    >
      <div className="flex flex-col h-full items-center justify-between pt-20 pb-12 px-6">
        
        {/* Indicators */}
        <div className="flex gap-2 mb-12">
          {slides.map((_, i) => (
            <div 
              key={i} 
              className={`h-2 rounded-full transition-all duration-300 ${i === currentSlide ? 'w-6' : 'w-2 bg-white/20'}`}
              style={{ backgroundColor: i === currentSlide ? slide.color : undefined }}
            />
          ))}
        </div>

        {/* Content */}
        <div className="flex-1 flex flex-col items-center justify-center w-full">
          <AnimatePresence mode="wait">
            <motion.div
              key={currentSlide}
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
              className="flex flex-col items-center text-center"
            >
              <div className="relative mb-8">
                <div className="absolute inset-0 rounded-full blur-xl opacity-30" style={{ backgroundColor: slide.color, transform: 'scale(1.5)' }} />
                <div className="w-32 h-32 rounded-full flex items-center justify-center relative z-10" style={{ backgroundColor: `${slide.color}20`, color: slide.color }}>
                  {slide.icon}
                </div>
              </div>

              <div 
                className="px-3 py-1 rounded-full text-[11px] font-mono font-bold mb-6"
                style={{ backgroundColor: `${slide.color}20`, color: slide.color }}
              >
                {slide.badge}
              </div>

              <h4 className="text-[12px] font-bold tracking-widest mb-2" style={{ color: slide.color }}>
                {slide.subtitle}
              </h4>
              <h2 className="text-[32px] font-bold leading-tight mb-4">
                {slide.title}
              </h2>
              <p className="text-white/70 text-[16px] leading-relaxed">
                {slide.desc}
              </p>
            </motion.div>
          </AnimatePresence>
        </div>

        {/* Actions */}
        <div className="w-full flex flex-col gap-3 mt-8">
          <button 
            onClick={nextSlide}
            className="w-full py-4 rounded-2xl font-bold text-[16px] transition-transform active:scale-[0.98] flex items-center justify-center gap-2 text-black"
            style={{ backgroundColor: slide.color }}
          >
            {currentSlide === slides.length - 1 ? 'Start Trading Securely' : 'Continue'}
            {currentSlide < slides.length - 1 && <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><path d="M5 12h14M12 5l7 7-7 7"/></svg>}
          </button>
          
          {currentSlide < slides.length - 1 && (
            <button 
              onClick={() => navigate('scan-item')}
              className="w-full py-4 text-white/50 font-medium text-[14px]"
            >
              Skip to App
            </button>
          )}
        </div>

      </div>
    </motion.div>
  );
}
