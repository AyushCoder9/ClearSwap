import React from 'react';

export function AppMockup() {
  return (
    <div className="relative w-full max-w-sm mx-auto -rotate-2 bg-white rounded-[22px] border-memphis shadow-memphis overflow-hidden z-10">
      {/* Browser / App Chrome Bar */}
      <div className="flex items-center px-4 py-3 border-b-3 border-ink bg-cream/30">
        <div className="flex gap-1.5 mr-4">
          <div className="w-3 h-3 rounded-full bg-coral border-2 border-ink" />
          <div className="w-3 h-3 rounded-full bg-mustard border-2 border-ink" />
          <div className="w-3 h-3 rounded-full bg-teal border-2 border-ink" />
        </div>
        <span className="font-sans font-bold text-xs tracking-tight">Active Escrow • iPhone 15 Pro</span>
      </div>

      {/* App Body */}
      <div className="p-5">
        <div className="flex items-center justify-between mb-6">
          <h3 className="font-display font-bold text-lg leading-tight">Radar Proximity</h3>
          <div className="bg-teal text-white font-sans font-bold text-xs px-3 py-1 rounded-full border-2 border-ink shadow-memphis-sm">
            850m away
          </div>
        </div>

        {/* Fake Radar Visualization */}
        <div className="relative w-full aspect-square border-3 border-ink rounded-xl overflow-hidden bg-ink/5 mb-6 flex items-center justify-center">
          <div className="absolute w-full h-full border-3 border-teal rounded-full scale-150 opacity-20" />
          <div className="absolute w-full h-full border-3 border-teal rounded-full scale-110 opacity-40 animate-ping" style={{ animationDuration: '3s' }} />
          <div className="absolute w-3/4 h-3/4 border-3 border-teal rounded-full opacity-60" />
          <div className="absolute w-1/2 h-1/2 border-3 border-teal rounded-full opacity-80" />
          <div className="absolute w-4 h-4 bg-teal border-2 border-ink rounded-full z-10 shadow-memphis-sm" />
          
          {/* Buyer dot */}
          <div className="absolute w-3 h-3 bg-coral border-2 border-ink rounded-full z-10 top-1/4 right-1/4 animate-bounce" />
        </div>

        {/* Checklist */}
        <div className="space-y-3">
          <div className="flex items-center gap-3 p-3 border-3 border-ink rounded-xl bg-white shadow-memphis-sm">
            <div className="w-5 h-5 bg-teal border-2 border-ink rounded-sm flex items-center justify-center">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
            </div>
            <span className="font-sans font-medium text-sm">Funds locked in escrow</span>
          </div>
          
          <div className="flex items-center gap-3 p-3 border-3 border-ink rounded-xl bg-white shadow-memphis-sm">
            <div className="w-5 h-5 bg-teal border-2 border-ink rounded-sm flex items-center justify-center">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
            </div>
            <span className="font-sans font-medium text-sm">Meetup proximity verified</span>
          </div>

          <div className="flex items-center gap-3 p-3 border-3 border-ink rounded-xl bg-white opacity-60">
            <div className="w-5 h-5 bg-white border-2 border-ink rounded-sm" />
            <span className="font-sans font-medium text-sm">Scan QR to release</span>
          </div>
        </div>
      </div>
    </div>
  );
}
