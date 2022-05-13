-- Proyecto Brazo Robotico
-- Primavera 2022
-- Lorena Mondragon
-- Bruno Vitte
-- Rogelio Torres

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity main is

port
(
	--in
	clk: in std_logic;
	psStart: in std_logic;
	psStop: in std_logic;
	dip: in std_logic_vector(2 downto 0);
	--out
	servo1, servo2, servo3, servo4: out std_logic;	-- 
	SSEG_sc:out std_logic_vector(6 downto 0)			-- 7 Segmentos
);
end main;

architecture arch of main is

	type Estados is (EdoReset, Idle, Edo1, Edo2,Edo3, Edo4, Edo5, Edo6, Edo7, Edo8, AumentaContador); -- AumentaContador para aumentar el valor del contador de 7 segmentos
	signal Edo: Estados;

	----- Señales temporales para el contador de eventos
	signal contEventos: unsigned(2 downto 0):= (others => '0');
	signal MaxValue: unsigned(2 downto 0):= (others => '0');

	----- Señales para el temporalizador
	signal contTiempo: unsigned(27 downto 0):= (others => '0');
	constant valMaxTime: unsigned(27 downto 0):= X"8F0D180";

	----- Señales temporales para los PWMs
	constant periodoPWM: unsigned(19 downto 0):= X"F4240";
	signal contPeriodoPWM: unsigned(19 downto 0):= (others => '0');
	-- Constantes de PWM;
	constant PWM1_EdoIdle: unsigned(19 downto 0):= X"124F8";
	constant PWM2_EdoIdle: unsigned(19 downto 0):= X"124F8";
	constant PWM3_EdoIdle: unsigned(19 downto 0):= X"124F8";
	constant PWM4_EdoIdle: unsigned(19 downto 0):= X"124F8";

	constant PWM1_Edo1: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Edo1: unsigned(19 downto 0):= X"124F8";
	constant PWM3_Edo1: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Edo1: unsigned(19 downto 0):= X"124F8";

	constant PWM1_Edo2: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Edo2: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Edo2: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Edo2: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Edo3: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Edo3: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Edo3: unsigned(19 downto 0):= X"0C350";
	constant PWM4_Edo3: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Edo4: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Edo4: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Edo4: unsigned(19 downto 0):= X"0C350";
	constant PWM4_Edo4: unsigned(19 downto 0):= X"0C350";
	
	constant PWM1_Edo5: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Edo5: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Edo5: unsigned(19 downto 0):= X"0C350";
	constant PWM4_Edo5: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Edo6: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Edo6: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Edo6: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Edo6: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Edo7: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Edo7: unsigned(19 downto 0):= X"124F8";
	constant PWM3_Edo7: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Edo7: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Edo8: unsigned(19 downto 0):= X"124F8";
	constant PWM2_Edo8: unsigned(19 downto 0):= X"124F8";
	constant PWM3_Edo8: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Edo8: unsigned(19 downto 0):= X"124F8";



begin

	--estados
	Maquina: process(clk, psStart, psStop, dip)
	begin
		if(rising_edge(clk))then
			case(Edo) is
				when EdoReset =>
					Edo <= Idle;

				when idle =>
					if(contEventos >= MaxValue)then
						Edo <= EdoReset;
					else
						if(psStart = '0')then
							Edo <= Edo1;
						else
							Edo <= idle;
						end if;
					end if;
					contTiempo <= (others => '0');
					--edo1
				when Edo1 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo1;
						else
							contTiempo <= (others => '0');
							Edo <= Edo2;
						end if;
					end if;
					--edo2
				when Edo2 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else						
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo2;
						else
							contTiempo <= (others => '0');
							Edo <= Edo3;--cambiaria a edo3 y el final seria AumentaContador
						end if;
					end if;
					--edo3
				when Edo3 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo3;
						else
							contTiempo <= (others => '0');
							Edo <= Edo4;
						end if;
					end if;
					--edo4
				when Edo4 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo4;
						else
							contTiempo <= (others => '0');
							Edo <= Edo5;
						end if;
					end if;
				--edo5
				when Edo5 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo5;
						else
							contTiempo <= (others => '0');
							Edo <= Edo6;
						end if;
					end if;

				--edo6
				when Edo6 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo6;
						else
							contTiempo <= (others => '0');
							Edo <= Edo7;
						end if;
					end if;
				--edo7
				when Edo7 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo7;
						else
							contTiempo <= (others => '0');
							Edo <= Edo8;
						end if;
					end if;
				--edo8
				when Edo8 =>
					if(psStop = '0')then
						Edo <= EdoReset;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Edo <= Edo8;
						else
							contTiempo <= (others => '0');
							Edo <= AumentaContador;
						end if;
					end if;
					--Aumenta Contador
				when AumentaContador =>
					Edo <= Idle;
				end case;
			end if;
			
		end process;
	
	process(MaxValue, Edo)
	begin
		if(Edo <= EdoReset)then
			MaxValue <= unsigned(dip);
		else
			MaxValue <= MaxValue;
		end if;
	end process;

	process(clk, Edo, contEventos)
	begin
		if(rising_edge(clk))then
			if(Edo = EdoReset)then
				contEventos <= unsigned(dip);
			elsif(Edo = AumentaContador)then
				contEventos <= contEventos + 1;
			else
				contEventos <= contEventos;
			end if;
		end if;
	end process;

	----- Creación del PWM; Periodo
	process(clk, Edo, contPeriodoPWM)
	begin
		if(rising_edge(clk))then
			-- Primer ServoMotor
			if(edo = EdoReset)then
				contPeriodoPWM <= (others => '0');
			else
				if(contPeriodoPWM < periodoPWM)then
					contPeriodoPWM <= contPeriodoPWM + 1;
				else
					contPeriodoPWM <= (others => '0');
				end if;
			end if;
		end if;
	end process;

	-- Creación del PWM: Señal
	process(clk, Edo, contPeriodoPWM)
	begin
		if(rising_edge(clk))then
			if(Edo = Idle)then
				if(contPeriodoPWM <= PWM1_EdoIdle)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_EdoIdle)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_EdoIdle)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_EdoIdle)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
				---edo1
			elsif(Edo = Edo1)then
				if(contPeriodoPWM <= PWM1_Edo1)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo1)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo1)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo1)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
				---------edo2
			elsif(Edo = Edo2)then
				if(contPeriodoPWM <= PWM1_Edo2)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo2)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo2)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo2)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
				------edo3
			elsif(Edo = Edo3)then
				if(contPeriodoPWM <= PWM1_Edo3)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo3)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo3)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo3)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
			--ed04
			elsif(Edo = Edo4)then
				if(contPeriodoPWM <= PWM1_Edo4)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo4)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo4)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo4)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
			--edo5
			elsif(Edo = Edo5)then
				if(contPeriodoPWM <= PWM1_Edo5)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo5)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo5)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo5)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
			--edo6
			elsif(Edo = Edo6)then
				if(contPeriodoPWM <= PWM1_Edo6)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo6)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo6)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo6)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
			--edo7
			elsif(Edo = Edo7)then
				if(contPeriodoPWM <= PWM1_Edo7)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo7)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo7)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo7)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
			--edo8
			elsif(Edo = Edo8)then
				if(contPeriodoPWM <= PWM1_Edo8)then
					servo1 <= '1';
				else
					servo1 <= '0';
				end if;
				if(contPeriodoPWM <= PWM2_Edo8)then
					servo2 <= '1';
				else
					servo2 <= '0';
				end if;
				if(contPeriodoPWM <= PWM3_Edo8)then
					servo3 <= '1';
				else
					servo3 <= '0';
				end if;
				if(contPeriodoPWM <= PWM4_Edo8)then
					servo4 <= '1';
				else
					servo4 <= '0';
				end if;
			end if;--if general
		end if;--rising edge
	end process;

	--'0' & contEventos
	
	process(contEventos)--hago el cambio al BCD de 7 segmentos
	begin
	 if(contEventos="000")then
	 SSEG_SC<="1111110";
	 end if; --0
	 
	 if(contEventos="001")then
	 SSEG_SC<="0110000";
	 end if;--1
	 
	 
	 if(contEventos="010")then
	 SSEG_SC<="1101101";
	 end if;--2
	 
	 if(contEventos="011")then
	 SSEG_SC<="1111001";
	 end if;--3
	 
	 if(contEventos="100")then
	 SSEG_SC<="0110011";
	 end if;--4
	 
	 if(contEventos="101")then
	 SSEG_SC<="1011011";
	 end if;--5
	 
	 if(contEventos="110")then
	 SSEG_SC<="1011111";
	 end if;--6
	 
	 if(contEventos="111")then
	 SSEG_SC<="1110000";
	 end if;--7
	end process;--llega nada más hasta 7 porque es el valor maximo con un dip de 3 posiciones.
	

end arch;%          