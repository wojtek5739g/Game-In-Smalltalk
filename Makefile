run:
	@rm -f merged.st
	@cat Player.st Animal.st Item.st Location.st Game.st > merged.st
	@gst merged.st