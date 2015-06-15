from myhdl import always, always_comb, always_seq, Signal, ResetSignal, toVerilog, toVHDL, delay, traceSignals, Simulation, now, intbv, concat

#Implementation

def elevator(clk, reset, en, F, D, Q, A, B, A_latch, B_latch, LED):

   @always_comb
   def encoder():
      if bool(F) and en:
         A.next = bool(F[3] or (F[1] and not F[2]))
         B.next = bool(F[2] or F[3])

   @always_comb
   def latch():
      if reset:
         A_latch.next = bool(False)
         B_latch.next = bool(False)
      elif bool(F) and en:
         A_latch.next = A
         B_latch.next = B

   @always_comb
   def logic():
      D.next = concat(   bool((not Q[3] and not Q[2] and not Q[1] and not Q[0] and B_latch and A_latch) or (not Q[3] and not Q[2] and Q[1] and not Q[0] and not B_latch and not A_latch) or (Q[3] and Q[2] and Q[1] and not Q[0]) or (not Q[3] and not Q[2] and Q[1] and Q[0] and not B_latch)),
                         bool((not Q[3] and not Q[2] and Q[1] and Q[0] and not B_latch and not A_latch) or (not Q[3] and not Q[2] and not Q[1] and B_latch and A_latch) or (Q[3] and Q[2] and not Q[1] and Q[0]) or (not Q[3] and not Q[2] and not Q[1] and not Q[0] and B_latch)),
                         bool((not Q[3] and not Q[2] and Q[1] and Q[0] and not B_latch) or (not Q[3] and not Q[2] and Q[0] and B_latch) or (Q[2] and not Q[1] and Q[0]) or (not Q[3] and Q[1] and not Q[0] and B_latch) or (not Q[3] and Q[2] and Q[1] and not Q[0])),
                         bool((not Q[3] and not Q[2] and Q[1] and not Q[0] and not B_latch and not A_latch) or (not Q[3] and not Q[2] and not Q[1] and not B_latch and A_latch) or (not Q[3] and not Q[2] and Q[1] and B_latch and A_latch) or (not Q[3] and not Q[2] and not Q[1] and not Q[0] and B_latch) or (Q[3] and Q[1] and not Q[0]) or (not Q[3] and Q[2] and Q[1] and not Q[0]) or (Q[1] and not Q[0] and A_latch))   )

   @always_seq(clk.posedge, reset)
   def dff():
      if en:
         Q.next = D

   @always_comb
   def decoder():
      LED.next = concat(   bool(Q[1] and Q[0]),
                           bool(Q[1] and not Q[0]),
                           bool(not Q[1] and Q[0]),
                           bool(not Q[1] and not Q[0])   )

   return encoder, latch, logic, dff, decoder


#Convert to Verilog

def convert():
   clk = Signal(bool(False))
   reset = ResetSignal(bool(False), bool(True), async=True)
   en = Signal(bool(True))
   F = Signal(intbv(0b0, 0b0, 0b10000))
   D = Signal(intbv(0b0, 0b0, 0b10000))
   Q = Signal(intbv(0b0, 0b0, 0b10000))
   A = Signal(bool(False))
   B = Signal(bool(False))
   A_latch = Signal(bool(False))
   B_latch = Signal(bool(False))
   LED = Signal(intbv(0b0, 0b0, 0b10000))
   toVerilog.timescale = "100ms/1ms"
   toVerilog(elevator, clk, reset, en, F, D, Q, A, B, A_latch, B_latch, LED)
   toVHDL(elevator, clk, reset, en, F, D, Q, A, B, A_latch, B_latch, LED)

convert()


#Simulate

def test_elevator():
   clk = Signal(bool(False))
   reset = ResetSignal(bool(False), bool(True), async=True)
   en = Signal(bool(True))
   F = Signal(intbv(0b0, 0b0, 0b10000))
   D = Signal(intbv(0b0, 0b0, 0b10000))
   Q = Signal(intbv(0b0, 0b0, 0b10000))
   A = Signal(bool(False))
   B = Signal(bool(False))
   A_latch = Signal(bool(False))
   B_latch = Signal(bool(False))
   LED = Signal(intbv(0b0, 0b0, 0b10000))
   elevator_inst = elevator(clk, reset, en, F, D, Q, A, B, A_latch, B_latch, LED)

   @always(delay(10))
   def clkgen():
      clk.next = not clk

   @always(delay(1))
   def stimulus():
      if now() == 45:
         F.next = Signal(intbv(0b0100))
      elif now() == 46:
         F.next = Signal(intbv(0b0000))
      elif now() == 60:
         F.next = Signal(intbv(0b0001))
      elif now() == 61:
         F.next = Signal(intbv(0b0000))
      elif now() == 150:
         F.next = Signal(intbv(0b0010))
      elif now() == 200:
         F.next = Signal(intbv(0b0011))
      elif now() == 250:
         F.next = Signal(intbv(0b0100))
      elif now() == 300:
         F.next = Signal(intbv(0b0101))
      elif now() == 350:
         F.next = Signal(intbv(0b0110))
      elif now() == 400:
         F.next = Signal(intbv(0b0111))
      elif now() == 450:
         F.next = Signal(intbv(0b1000))
      elif now() == 500:
         F.next = Signal(intbv(0b1001))
      elif now() == 550:
         F.next = Signal(intbv(0b1010))
      elif now() == 600:
         F.next = Signal(intbv(0b1011))
      elif now() == 650:
         F.next = Signal(intbv(0b1100))
         #reset.next = 0b1
      elif now() == 700:
         F.next = Signal(intbv(0b1101))
      elif now() == 750:
         F.next = Signal(intbv(0b1110))
      elif now() == 800:
         F.next = Signal(intbv(0b0001))
      elif now() == 850:
         F.next = Signal(intbv(0b1000))
         #reset.next = 0b0
      elif now() == 900:
         F.next = Signal(intbv(0b0010))
      elif now() == 950:
         F.next = Signal(intbv(0b1000))
         #en.next = 0b0
      elif now() == 1000:
         F.next = Signal(intbv(0b0001))
      elif now() == 1050:
         F.next = Signal(intbv(0b0100))
      elif now() == 1100:
         F.next = Signal(intbv(0b0001))
      elif now() == 1150:
         F.next = Signal(intbv(0b0100))
      elif now() == 1200:
         F.next = Signal(intbv(0b0000))
      elif now() == 1240:
         F.next = Signal(intbv(0b0000))
         #en.next = 0b1
      elif now() == 1360:
         F.next = Signal(intbv(0b0001))
      elif now() == 1370:
         F.next = Signal(intbv(0b1001))

   return elevator_inst, clkgen, stimulus#, reset_test, en_test


def simulate(timesteps):
   traceSignals.timescale = "100ms"
   tb = traceSignals(test_elevator)
   sim = Simulation(tb)
   sim.run(timesteps)

simulate(1500)
