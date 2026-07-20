import React from 'react';

export function HowItWorks() {
  const steps = [
    { num: 1, title: "Lock Funds", desc: "Buyer sends funds to the mathematically locked smart contract. Seller gets instantly notified.", color: "bg-coral" },
    { num: 2, title: "Meetup Radar", desc: "Use the live map to safely locate each other. Our radar pulses green when you're within 10 meters.", color: "bg-mustard" },
    { num: 3, title: "Scan to Release", desc: "Scan the buyer's unique dynamic QR code. FaceID validates the identity, and cash drops to your bank instantly.", color: "bg-teal" },
  ];

  return (
    <section id="how-it-works" className="relative z-10 w-full bg-violet border-y-3 border-ink py-24 lg:py-32 overflow-hidden">
      <div className="absolute inset-0 opacity-10" style={{ backgroundImage: 'radial-gradient(var(--color-cream) 2px, transparent 2px)', backgroundSize: '24px 24px' }} />
      
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        <h2 className="font-display font-extrabold text-[46px] leading-[1.05] tracking-tight text-cream mb-16 max-w-2xl">
          Three steps to <br/>bulletproof trading.
        </h2>

        <div className="grid md:grid-cols-3 gap-8 relative">
          {/* Connector Line */}
          <div className="hidden md:block absolute top-[40px] left-[10%] right-[10%] h-1 bg-ink border-y-2 border-ink border-dashed z-0" />

          {steps.map((step) => (
            <div key={step.num} className="relative z-10 flex flex-col items-start group">
              <div className={`w-[80px] h-[80px] rounded-full border-[4px] border-ink ${step.color} shadow-memphis flex items-center justify-center font-display font-black text-3xl text-white mb-8 group-hover:-translate-y-2 transition-transform duration-300`}>
                {step.num}
              </div>
              <div className="bg-white rounded-[22px] border-memphis p-8 shadow-memphis w-full h-full">
                <h3 className="font-display font-bold text-2xl mb-4">{step.title}</h3>
                <p className="font-sans text-ink/80 text-[15px] leading-relaxed">
                  {step.desc}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
