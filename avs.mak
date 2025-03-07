# ST Visual Debugger Generated MAKE File, based on avs.stp

ifeq ($(CFG), )
CFG=Debug
$(warning ***No configuration specified. Defaulting to $(CFG)***)
endif

ToolsetRoot=C:\PROGRA~2\COSMIC\FSE_CO~1
ToolsetBin=C:\Program Files (x86)\COSMIC\FSE_Compilers
ToolsetInc=C:\Program Files (x86)\COSMIC\FSE_Compilers\Hstm8
ToolsetLib=C:\Program Files (x86)\COSMIC\FSE_Compilers\Lib
ToolsetIncOpts=-i"C:\Program Files (x86)\COSMIC\FSE_Compilers\Hstm8" 
ToolsetLibOpts=-l"C:\Program Files (x86)\COSMIC\FSE_Compilers\Lib" 
ObjectExt=o
OutputExt=elf
InputName=$(basename $(notdir $<))


# 
# Debug
# 
ifeq "$(CFG)" "Debug"


OutputPath=Debug
ProjectSFile=avs
TargetSName=$(ProjectSFile)
TargetFName=$(ProjectSFile).elf
IntermPath=$(dir $@)
CFLAGS_PRJ=$(ToolsetBin)\cxstm8  +mods0 +debug -pxp +split -pp -l -iinclude $(ToolsetIncOpts) -cl$(IntermPath:%\=%) -co$(IntermPath:%\=%) $<
ASMFLAGS_PRJ=$(ToolsetBin)\castm8  -xx -l $(ToolsetIncOpts) -o$(IntermPath)$(InputName).$(ObjectExt) $<

all : $(OutputPath) $(ProjectSFile).elf

$(OutputPath) : 
	if not exist $(OutputPath)/ mkdir $(OutputPath)

Debug\adc.$(ObjectExt) : source\adc.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\adc.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\asp.$(ObjectExt) : source\asp.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\avs.$(ObjectExt) : source\avs.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\eeprom.$(ObjectExt) : source\eeprom.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\gpio.$(ObjectExt) : source\gpio.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

"Debug\interrupt priority.$(ObjectExt)" : source\INTERR~1.C ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\leds.$(ObjectExt) : source\leds.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\main.$(ObjectExt) : source\main.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\outputvoltage.$(ObjectExt) : source\outputvoltage.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\adc.h include\timers.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\relay.$(ObjectExt) : source\relay.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\stm8s_it.$(ObjectExt) : source\stm8s_it.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s_type.h include\timers.h include\globals.h include\gpio.h include\stm8s_it.h include\stm8s.h include\stm8s_conf.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\test.$(ObjectExt) : source\test.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h include\adc.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\timers.$(ObjectExt) : source\timers.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\stm8s_it.h include\timers.h include\globals.h include\gpio.h include\relay.h include\eeprom.h include\leds.h include\avs.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\uart.$(ObjectExt) : source\uart.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Debug\stm8_interrupt_vector.$(ObjectExt) : stm8_interrupt_vector.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s_it.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

$(ProjectSFile).elf :  $(OutputPath)\adc.o $(OutputPath)\asp.o $(OutputPath)\avs.o $(OutputPath)\eeprom.o $(OutputPath)\gpio.o "$(OutputPath)\interrupt priority.o" $(OutputPath)\leds.o $(OutputPath)\main.o $(OutputPath)\outputvoltage.o $(OutputPath)\relay.o $(OutputPath)\stm8s_it.o $(OutputPath)\test.o $(OutputPath)\timers.o $(OutputPath)\uart.o $(OutputPath)\stm8_interrupt_vector.o $(OutputPath)\avs.lkf
	$(ToolsetBin)\clnk  $(ToolsetLibOpts) -o $(OutputPath)\$(TargetSName).sm8 -m$(OutputPath)\$(TargetSName).map -m$(OutputPath)\$(TargetSName).map $(OutputPath)\$(TargetSName).lkf 
	$(ToolsetBin)\cvdwarf  $(OutputPath)\$(TargetSName).sm8

	$(ToolsetBin)\chex  -o $(OutputPath)\$(TargetSName).s19 $(OutputPath)\$(TargetSName).sm8
	find  "segment" $(OutputPath)\$(TargetSName).map
clean : 
	-@erase $(OutputPath)\adc.o
	-@erase $(OutputPath)\asp.o
	-@erase $(OutputPath)\avs.o
	-@erase $(OutputPath)\eeprom.o
	-@erase $(OutputPath)\gpio.o
	-@erase $(OutputPath)\interrupt priority.o
	-@erase $(OutputPath)\leds.o
	-@erase $(OutputPath)\main.o
	-@erase $(OutputPath)\outputvoltage.o
	-@erase $(OutputPath)\relay.o
	-@erase $(OutputPath)\stm8s_it.o
	-@erase $(OutputPath)\test.o
	-@erase $(OutputPath)\timers.o
	-@erase $(OutputPath)\uart.o
	-@erase $(OutputPath)\stm8_interrupt_vector.o
	-@erase $(OutputPath)\avs.elf
	-@erase $(OutputPath)\avs.elf
	-@erase $(OutputPath)\avs.map
	-@erase $(OutputPath)\adc.ls
	-@erase $(OutputPath)\asp.ls
	-@erase $(OutputPath)\avs.ls
	-@erase $(OutputPath)\eeprom.ls
	-@erase $(OutputPath)\gpio.ls
	-@erase $(OutputPath)\interrupt priority.ls
	-@erase $(OutputPath)\leds.ls
	-@erase $(OutputPath)\main.ls
	-@erase $(OutputPath)\outputvoltage.ls
	-@erase $(OutputPath)\relay.ls
	-@erase $(OutputPath)\stm8s_it.ls
	-@erase $(OutputPath)\test.ls
	-@erase $(OutputPath)\timers.ls
	-@erase $(OutputPath)\uart.ls
	-@erase $(OutputPath)\stm8_interrupt_vector.ls
endif

# 
# Release
# 
ifeq "$(CFG)" "Release"


OutputPath=Release
ProjectSFile=avs
TargetSName=$(ProjectSFile)
TargetFName=$(ProjectSFile).elf
IntermPath=$(dir $@)
CFLAGS_PRJ=$(ToolsetBin)\cxstm8  +mods0 +compact +split -pp -iinclude $(ToolsetIncOpts) -cl$(IntermPath:%\=%) -co$(IntermPath:%\=%) $<
ASMFLAGS_PRJ=$(ToolsetBin)\castm8  $(ToolsetIncOpts) -o$(IntermPath)$(InputName).$(ObjectExt) $<

all : $(OutputPath) $(ProjectSFile).elf

$(OutputPath) : 
	if not exist $(OutputPath)/ mkdir $(OutputPath)

Release\adc.$(ObjectExt) : source\adc.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\adc.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\asp.$(ObjectExt) : source\asp.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\avs.$(ObjectExt) : source\avs.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\eeprom.$(ObjectExt) : source\eeprom.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\gpio.$(ObjectExt) : source\gpio.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

"Release\interrupt priority.$(ObjectExt)" : source\INTERR~1.C ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\leds.$(ObjectExt) : source\leds.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\main.$(ObjectExt) : source\main.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\outputvoltage.$(ObjectExt) : source\outputvoltage.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\adc.h include\timers.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\relay.$(ObjectExt) : source\relay.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\timers.h include\adc.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\stm8s_it.$(ObjectExt) : source\stm8s_it.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s_type.h include\timers.h include\globals.h include\gpio.h include\stm8s_it.h include\stm8s.h include\stm8s_conf.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\test.$(ObjectExt) : source\test.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h include\adc.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\timers.$(ObjectExt) : source\timers.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\stm8s_it.h include\timers.h include\globals.h include\gpio.h include\relay.h include\eeprom.h include\leds.h include\avs.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\uart.$(ObjectExt) : source\uart.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h include\globals.h include\gpio.h include\stm8s_it.h include\relay.h include\eeprom.h include\leds.h include\avs.h include\options.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

Release\stm8_interrupt_vector.$(ObjectExt) : stm8_interrupt_vector.c ..\..\..\PROGRA~2\cosmic\FSE_CO~1\cxstm8\hstm8\mods0.h include\stm8s_it.h include\stm8s.h include\stm8s_type.h include\stm8s_conf.h 
	@if not exist $(dir $@)  mkdir $(dir $@)
	$(CFLAGS_PRJ)

$(ProjectSFile).elf :  $(OutputPath)\adc.o $(OutputPath)\asp.o $(OutputPath)\avs.o $(OutputPath)\eeprom.o $(OutputPath)\gpio.o "$(OutputPath)\interrupt priority.o" $(OutputPath)\leds.o $(OutputPath)\main.o $(OutputPath)\outputvoltage.o $(OutputPath)\relay.o $(OutputPath)\stm8s_it.o $(OutputPath)\test.o $(OutputPath)\timers.o $(OutputPath)\uart.o $(OutputPath)\stm8_interrupt_vector.o $(OutputPath)\avs.lkf
	$(ToolsetBin)\clnk  $(ToolsetLibOpts) -o $(OutputPath)\$(TargetSName).sm8 -m$(OutputPath)\$(TargetSName).map $(OutputPath)\$(TargetSName).lkf 
	$(ToolsetBin)\cvdwarf  $(OutputPath)\$(TargetSName).sm8

	$(ToolsetBin)\chex  -o $(OutputPath)\$(TargetSName).s19 $(OutputPath)\$(TargetSName).sm8
	find  "segment" $(OutputPath)\$(TargetSName).map
clean : 
	-@erase $(OutputPath)\adc.o
	-@erase $(OutputPath)\asp.o
	-@erase $(OutputPath)\avs.o
	-@erase $(OutputPath)\eeprom.o
	-@erase $(OutputPath)\gpio.o
	-@erase $(OutputPath)\interrupt priority.o
	-@erase $(OutputPath)\leds.o
	-@erase $(OutputPath)\main.o
	-@erase $(OutputPath)\outputvoltage.o
	-@erase $(OutputPath)\relay.o
	-@erase $(OutputPath)\stm8s_it.o
	-@erase $(OutputPath)\test.o
	-@erase $(OutputPath)\timers.o
	-@erase $(OutputPath)\uart.o
	-@erase $(OutputPath)\stm8_interrupt_vector.o
	-@erase $(OutputPath)\avs.elf
	-@erase $(OutputPath)\avs.elf
	-@erase $(OutputPath)\adc.ls
	-@erase $(OutputPath)\asp.ls
	-@erase $(OutputPath)\avs.ls
	-@erase $(OutputPath)\eeprom.ls
	-@erase $(OutputPath)\gpio.ls
	-@erase $(OutputPath)\interrupt priority.ls
	-@erase $(OutputPath)\leds.ls
	-@erase $(OutputPath)\main.ls
	-@erase $(OutputPath)\outputvoltage.ls
	-@erase $(OutputPath)\relay.ls
	-@erase $(OutputPath)\stm8s_it.ls
	-@erase $(OutputPath)\test.ls
	-@erase $(OutputPath)\timers.ls
	-@erase $(OutputPath)\uart.ls
	-@erase $(OutputPath)\stm8_interrupt_vector.ls
endif
