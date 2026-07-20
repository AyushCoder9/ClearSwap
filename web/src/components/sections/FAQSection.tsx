'use client';
import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

const faqs = [
  {
    q: "How does the Zero-Trust Escrow work?",
    a: "When a deal is agreed upon, the buyer's funds are held in a secure, mathematically locked escrow. The seller knows the money is there, and the buyer knows the seller can't take it until they both verify the meetup in person using FaceID and our dynamic QR scan."
  },
  {
    q: "Is there a fee to use ClearSwap?",
    a: "During our beta phase, we are taking 0% fees on all transactions. You keep exactly what you sell your item for."
  },
  {
    q: "How do I get my money after the scan?",
    a: "Instantly. The moment the QR code is verified, funds are routed directly to your connected bank account via IMPS/UPI. No 3-day holding periods."
  }
];

export function FAQSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  return (
    <section className="relative z-10 max-w-4xl mx-auto px-6 py-24 lg:py-32">
      <h2 className="font-display font-extrabold text-[46px] leading-[1.05] tracking-tight mb-12 text-center">
        Questions?<br/>We got answers.
      </h2>

      <div className="space-y-6">
        {faqs.map((faq, index) => (
          <div 
            key={index} 
            className="bg-white border-memphis shadow-memphis rounded-[22px] overflow-hidden"
          >
            <button 
              className="w-full px-6 py-6 text-left flex justify-between items-center bg-cream/50 hover:bg-cream transition-colors"
              onClick={() => setOpenIndex(openIndex === index ? null : index)}
            >
              <span className="font-display font-bold text-xl">{faq.q}</span>
              <div className={`w-8 h-8 rounded-full border-2 border-ink flex items-center justify-center transition-transform ${openIndex === index ? 'bg-coral rotate-180' : 'bg-teal'}`}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>
              </div>
            </button>
            
            <AnimatePresence>
              {openIndex === index && (
                <motion.div
                  initial={{ height: 0 }}
                  animate={{ height: 'auto' }}
                  exit={{ height: 0 }}
                  className="overflow-hidden"
                >
                  <div className="px-6 pb-6 pt-2 font-sans text-ink/70 leading-relaxed border-t-3 border-ink">
                    {faq.a}
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        ))}
      </div>
    </section>
  );
}
