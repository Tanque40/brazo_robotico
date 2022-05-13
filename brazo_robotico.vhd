-- Proyecto Brazo Robotico
-- Primavera 2022
-- Lorena Mondragon
-- Bruno Vitte
-- Rogelio Torres

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity brazo_robotico is

port
(
	--in
	reloj: in std_logic;
	btInicio: in std_logic;
	btPara: in std_logic;
	dip: in std_logic_vector(2 downto 0);
	--out
	servomotor1, servomotor2, servomotor3, servomotor4: out std_logic;	-- 
	SSEG_sc:out std_logic_vector(6 downto 0)			
);
end brazo_robotico;

architecture arch of brazo_robotico is

	type Estados is (EstadoR, EstadoIdle, Estado1, Estado2, Estado3, Estado4, Estado5, Estado6, Estado7, Estado8, MasCont); 
	signal Estado: Estados;

    -- ST contador
	signal contadorEventos: unsigned(2 downto 0):= (others => '0');
	signal MaxValue: unsigned(2 downto 0):= (others => '0');

	-- ST
	signal contTiempo: unsigned(27 downto 0):= (others => '0');
	constant valMaxTime: unsigned(27 downto 0):= X"8F0D180";

    -- ST
	constant periodoPWM: unsigned(19 downto 0):= X"F4240";
	signal contadorPerPWM: unsigned(19 downto 0):= (others => '0');
	
    -- PWM;
	constant PWM1_EstadoEstadoIdle: unsigned(19 downto 0):= X"124F8";
	constant PWM2_EstadoEstadoIdle: unsigned(19 downto 0):= X"124F8";
	constant PWM3_EstadoEstadoIdle: unsigned(19 downto 0):= X"124F8";
	constant PWM4_EstadoEstadoIdle: unsigned(19 downto 0):= X"124F8";

	constant PWM1_Estado1: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Estado1: unsigned(19 downto 0):= X"124F8";
	constant PWM3_Estado1: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Estado1: unsigned(19 downto 0):= X"124F8";

	constant PWM1_Estado2: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Estado2: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Estado2: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Estado2: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Estado3: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Estado3: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Estado3: unsigned(19 downto 0):= X"0C350";
	constant PWM4_Estado3: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Estado4: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Estado4: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Estado4: unsigned(19 downto 0):= X"0C350";
	constant PWM4_Estado4: unsigned(19 downto 0):= X"0C350";
	
	constant PWM1_Estado5: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Estado5: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Estado5: unsigned(19 downto 0):= X"0C350";
	constant PWM4_Estado5: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Estado6: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Estado6: unsigned(19 downto 0):= X"0C350";
	constant PWM3_Estado6: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Estado6: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Estado7: unsigned(19 downto 0):= X"0C350";
	constant PWM2_Estado7: unsigned(19 downto 0):= X"124F8";
	constant PWM3_Estado7: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Estado7: unsigned(19 downto 0):= X"124F8";
	
	constant PWM1_Estado8: unsigned(19 downto 0):= X"124F8";
	constant PWM2_Estado8: unsigned(19 downto 0):= X"124F8";
	constant PWM3_Estado8: unsigned(19 downto 0):= X"124F8";
	constant PWM4_Estado8: unsigned(19 downto 0):= X"124F8";

    begin

	--7 estados
	Maquina: process(reloj, btInicio, btPara, dip)
	begin
		if(rising_edge(reloj))then
			case(Estado) is
				when EstadoR =>
					Estado <= EstadoIdle;

				when EstadoIdle =>
					if(contadorEventos >= MaxValue)then
						Estado <= EstadoR;
					else
						if(btInicio = '0')then
							Estado <= Estado1;
						else
							Estado <= EstadoIdle;
						end if;
					end if;
					contTiempo <= (others => '0');
					-- Primer estado
				when Estado1 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado1;
						else
							contTiempo <= (others => '0');
							Estado <= Estado2;
						end if;
					end if;
					--Estado2
				when Estado2 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else						
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado2;
						else
							contTiempo <= (others => '0');
							Estado <= Estado3;
						end if;
					end if;
					--Estado3
				when Estado3 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado3;
						else
							contTiempo <= (others => '0');
							Estado <= Estado4;
						end if;
					end if;
					--Estado4
				when Estado4 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado4;
						else
							contTiempo <= (others => '0');
							Estado <= Estado5;
						end if;
					end if;
				--Estado5
				when Estado5 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado5;
						else
							contTiempo <= (others => '0');
							Estado <= Estado6;
						end if;
					end if;
				--Estado6
				when Estado6 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado6;
						else
							contTiempo <= (others => '0');
							Estado <= Estado7;
						end if;
					end if;
				--Estado7
				when Estado7 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado7;
						else
							contTiempo <= (others => '0');
							Estado <= Estado8;
						end if;
					end if;
				--Estado8
				when Estado8 =>
					if(btPara = '0')then
						Estado <= EstadoR;
					else
						if(contTiempo <= valMaxTime)then
							contTiempo <= contTiempo + 1;
							Estado <= Estado8;
						else
							contTiempo <= (others => '0');
							Estado <= MasCont;
						end if;
					end if;
					--Sumamos uno al contador
				when MasCont =>
					Estado <= EstadoIdle;
				end case;
			end if;
			
		end process;
	
	process(MaxValue, Estado)
	begin
		if(Estado <= EstadoR)then
			MaxValue <= unsigned(dip);
		else
			MaxValue <= MaxValue;
		end if;
	end process;

	process(reloj, Estado, contadorEventos)
	begin
		if(rising_edge(reloj))then
			if(Estado = EstadoR)then
				contadorEventos <= unsigned(dip);
			elsif(Estado = MasCont)then
				contadorEventos <= contadorEventos + 1;
			else
				contadorEventos <= contadorEventos;
			end if;
		end if;
	end process;

	-- Crea Periodo
	process(reloj, Estado, contadorPerPWM)
	begin
		if(rising_edge(reloj))then
			-- Primer ServoMotor
			if(Estado = EstadoR)then
				contadorPerPWM <= (others => '0');
			else
				if(contadorPerPWM < periodoPWM)then
					contadorPerPWM <= contadorPerPWM + 1;
				else
					contadorPerPWM <= (others => '0');
				end if;
			end if;
		end if;
	end process;

	-- Crea Señal
	process(reloj, Estado, contadorPerPWM)
	begin
		if(rising_edge(reloj))then
			if(Estado = EstadoIdle)then
				if(contadorPerPWM <= PWM1_EstadoEstadoIdle)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_EstadoEstadoIdle)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_EstadoEstadoIdle)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_EstadoEstadoIdle)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
				--
			elsif(Estado = Estado1)then
				if(contadorPerPWM <= PWM1_Estado1)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado1)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado1)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado1)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
				--Estado2
			elsif(Estado = Estado2)then
				if(contadorPerPWM <= PWM1_Estado2)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado2)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado2)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado2)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
				--Estado3
			elsif(Estado = Estado3)then
				if(contadorPerPWM <= PWM1_Estado3)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado3)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado3)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado3)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
			--ed04
			elsif(Estado = Estado4)then
				if(contadorPerPWM <= PWM1_Estado4)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado4)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado4)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado4)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
			--Estado5
			elsif(Estado = Estado5)then
				if(contadorPerPWM <= PWM1_Estado5)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado5)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado5)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado5)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
			--Estado6
			elsif(Estado = Estado6)then
				if(contadorPerPWM <= PWM1_Estado6)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado6)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado6)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado6)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
			--Estado7
			elsif(Estado = Estado7)then
				if(contadorPerPWM <= PWM1_Estado7)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado7)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado7)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado7)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
			--Estado8
			elsif(Estado = Estado8)then
				if(contadorPerPWM <= PWM1_Estado8)then
					servomotor1 <= '1';
				else
					servomotor1 <= '0';
				end if;
				if(contadorPerPWM <= PWM2_Estado8)then
					servomotor2 <= '1';
				else
					servomotor2 <= '0';
				end if;
				if(contadorPerPWM <= PWM3_Estado8)then
					servomotor3 <= '1';
				else
					servomotor3 <= '0';
				end if;
				if(contadorPerPWM <= PWM4_Estado8)then
					servomotor4 <= '1';
				else
					servomotor4 <= '0';
				end if;
			end if;
		end if;
	end process;

    --ContadorEvecntos	
	process(contadorEventos)
	begin
	 if(contadorEventos="000")then
	 SSEG_SC<="1111110";
	 end if; --0
	 
	 if(contadorEventos="001")then
	 SSEG_SC<="0110000";
	 end if;--1
	 
	 
	 if(contadorEventos="010")then
	 SSEG_SC<="1101101";
	 end if;--2
	 
	 if(contadorEventos="011")then
	 SSEG_SC<="1111001";
	 end if;--3
	 
	 if(contadorEventos="100")then
	 SSEG_SC<="0110011";
	 end if;--4
	 
	 if(contadorEventos="101")then
	 SSEG_SC<="1011011";
	 end if;--5
	 
	 if(contadorEventos="110")then
	 SSEG_SC<="1011111";
	 end if;--6
	 
	 if(contadorEventos="111")then
	 SSEG_SC<="1110000";
	 end if;--7
	end process;
end arch;

