help:
	@echo "clean: Removes work and out directories"
	@echo "desktop: Build GravityOS with the desktop configuration"

desktop:
	mkdir work
	mkdir out
	cp gos-desktop/pacman.conf work/
	sudo mkarchiso -v -w work -o out gos-desktop

clean:
	@echo "WARNING: Make sure you've used findmnt to ensure no mount binds are in the directories before continuing, press ctrl+c to cancel or enter to continue"
	@read
	sudo rm -rf work
	sudo rm -rf out
