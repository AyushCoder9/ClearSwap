'use client';
import { CandyButton } from "@/components/ui/CandyButton";
import { MarkerHighlight } from "@/components/ui/MarkerHighlight";
import { ConfettiShape } from "@/components/ui/ConfettiShape";
import { AppMockup } from "@/components/ui/AppMockup";
import { FeatureCard } from "@/components/ui/FeatureCard";
import { BarChart3, ShieldCheck, Wallet } from "lucide-react";
import { HowItWorks } from "@/components/sections/HowItWorks";
import { FAQSection } from "@/components/sections/FAQSection";
import { Footer } from "@/components/sections/Footer";
import { SimulatorModal } from "@/components/simulator/SimulatorModal";
import { useSimulator } from "@/components/providers/SimulatorProvider";

export default function Home() {
  const { openSimulator } = useSimulator();

  return (
    <main className="min-h-screen relative overflow-hidden bg-cream">
      <SimulatorModal />

      {/* Animated Memphis Confetti Background */}
      <div className="absolute inset-0 pointer-events-none overflow-hidden z-0">
        <ConfettiShape type="triangle" color="var(--color-coral)" className="top-[10%] left-[10%]" animation="animate-drift" />
        <ConfettiShape type="quarter-arc" color="var(--color-teal)" className="top-[20%] right-[15%]" animation="animate-bob" />
        <ConfettiShape type="dotted-circle" color="var(--color-mustard)" className="top-[60%] left-[5%]" animation="animate-spin-slow" size={96} />
        <ConfettiShape type="plus" color="var(--color-violet)" className="top-[40%] left-[45%]" animation="animate-spin-slow" />
        <ConfettiShape type="squiggle" color="var(--color-ink)" className="top-[70%] right-[10%]" animation="animate-sway" size={80} />
        <ConfettiShape type="half-circle" color="var(--color-mustard)" className="top-[5%] right-[40%]" animation="animate-drift" />
        <ConfettiShape type="dot" color="var(--color-teal)" className="bottom-[10%] left-[30%]" animation="animate-bob" size={32} />
        <ConfettiShape type="zigzag" color="var(--color-sky)" className="bottom-[20%] right-[30%]" animation="animate-sway" />
        <ConfettiShape type="striped-circle" color="var(--color-coral)" className="top-[30%] left-[25%]" animation="animate-spin-slow" size={72} />
      </div>

      {/* Top Nav */}
      <nav className="relative z-50 max-w-7xl mx-auto px-6 py-8 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <div className="w-11 h-11 bg-mustard rounded-[12px] border-memphis shadow-memphis-sm flex items-center justify-center">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--color-ink)" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
              <path d="M4 12c4-8 4-8 8 0s4 8 8 0" />
            </svg>
          </div>
          <span className="font-display font-extrabold text-[26px] tracking-tight text-ink">ClearSwap</span>
        </div>

        <CandyButton onClick={() => openSimulator('onboarding')} variant="accent" size="sm">Run Simulator</CandyButton>
      </nav>

      {/* Hero Section */}
      <section className="relative z-10 max-w-7xl mx-auto px-6 pt-16 pb-24 lg:pt-24 lg:pb-32 grid lg:grid-cols-[1.05fr_0.95fr] gap-12 items-center">
        {/* Left Copy */}
        <div className="max-w-xl">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-violet text-white font-sans font-bold text-[14px] uppercase tracking-wider rounded-full border-memphis shadow-memphis-sm mb-8">
            <span className="w-2 h-2 rounded-full bg-mustard border-[1.5px] border-ink" />
            NEW - Apple Wallet Integration
          </div>
          
          <h1 className="font-display font-extrabold text-[52px] lg:text-[76px] leading-[0.98] tracking-tight mb-8">
            Trade <MarkerHighlight color="mustard" rotation="-2deg">secondhand</MarkerHighlight> without getting <MarkerHighlight color="teal" rotation="1deg">scammed.</MarkerHighlight>
          </h1>
          
          <p className="font-sans text-[19px] text-ink/80 font-medium mb-10 leading-relaxed">
            ClearSwap is the loud, zero-trust P2P escrow terminal that locks funds and releases them natively using FaceID and Apple Wallet. Stop guessing prices, stop carrying cash.
          </p>

          <div className="flex flex-col sm:flex-row items-center gap-6 mb-6">
            <CandyButton onClick={() => openSimulator('onboarding')} variant="primary" size="lg" className="w-full sm:w-auto">Run Simulator</CandyButton>
            <CandyButton onClick={() => { document.getElementById('how-it-works')?.scrollIntoView({ behavior: 'smooth' }) }} variant="secondary" size="lg" className="w-full sm:w-auto">See the steps</CandyButton>
          </div>

          <div className="bg-mustard/20 border-2 border-ink rounded-[12px] p-4 mb-12 shadow-[4px_4px_0px_var(--color-ink)] flex items-start gap-3">
            <svg className="shrink-0 mt-0.5" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-ink)" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
            <p className="font-sans font-bold text-[14px] text-ink leading-snug">
              Note: This is an interactive web simulation for demonstration purposes. The real native iOS application will be deployed soon.
            </p>
          </div>

          <div className="flex items-center gap-4">
            <div className="flex -space-x-4">
              {['bg-coral', 'bg-teal', 'bg-violet', 'bg-mustard'].map((color, i) => (
                <div key={i} className={`w-12 h-12 rounded-full ${color} border-memphis flex items-center justify-center font-display font-bold text-white text-lg`}>
                  {String.fromCharCode(65 + i)}
                </div>
              ))}
            </div>
            <p className="font-sans font-medium text-sm text-ink leading-snug max-w-[200px]">
              <span className="font-bold">Securing ₹12M+</span> in P2P trades.<br/>
              No escrow fees today.
            </p>
          </div>
        </div>

        {/* Right Product Mockup */}
        <div className="w-full flex justify-center lg:justify-end perspective-1000">
          <div onClick={() => openSimulator('radar')} className="cursor-pointer group">
             <div className="group-hover:scale-105 transition-transform duration-300">
               <AppMockup />
             </div>
          </div>
        </div>
      </section>

      {/* Logo Strip */}
      <section className="relative z-10 w-full bg-ink border-y-3 border-ink py-8 overflow-hidden">
        <div className="max-w-7xl mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-8">
          <span className="font-sans font-bold text-mustard text-sm uppercase tracking-[0.2em]">
            SECURED TRANSACTIONS FOR USERS OF
          </span>
          <div className="flex items-center gap-8 md:gap-12 opacity-85 overflow-x-auto w-full md:w-auto no-scrollbar">
            {['eBay', 'Craigslist', 'Carousell', 'Marketplace', 'Gumtree'].map((brand) => (
              <span key={brand} className="font-display font-bold text-cream text-2xl tracking-tight shrink-0">
                {brand}
              </span>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="relative z-10 max-w-7xl mx-auto px-6 py-24 lg:py-32 flex flex-col items-center">
        <div className="inline-flex items-center justify-center px-4 py-1.5 bg-violet text-white font-sans font-bold text-sm uppercase tracking-wider rounded-full border-memphis shadow-memphis-sm mb-6">
          Why sellers switch
        </div>
        <h2 className="font-display font-extrabold text-[46px] leading-[1.05] tracking-tight text-center max-w-2xl mb-16">
          Boring banking apps kill deals.<br/>ClearSwap secures them natively.
        </h2>

        <div className="grid md:grid-cols-3 gap-8 w-full">
          <FeatureCard 
            color="coral"
            title="Market Intelligence"
            description="Drag our interactive bell curve to see real-time price distributions. Stop guessing and lock in fair market value."
            icon={<BarChart3 size={32} color="white" />}
          />
          <FeatureCard 
            color="teal"
            title="Zero-Trust Escrow"
            description="Funds are locked cryptographically before you meet. Scan the dynamic QR and verify via FaceID to release cash instantly."
            icon={<ShieldCheck size={32} color="white" />}
          />
          <FeatureCard 
            color="violet"
            title="Verified Receipts"
            description="The moment payment clears, a signed receipt drops straight into Apple Wallet tracking serials and warranties."
            icon={<Wallet size={32} color="white" />}
          />
        </div>
      </section>

      <HowItWorks />
      <FAQSection />
      <Footer />
    </main>
  );
}
