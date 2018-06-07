//delay(2)

function wiggle() {
    var step = 2.5;
    var iterations = 5;

    bounds = app.windows[0].bounds();

	for(i=0; i<iterations; i++) {
        bounds["x"] = Number(bounds["x"]) - step
	    app.windows[0].bounds = bounds
	}

	for(i=0; i<(iterations*2); i++) {
        bounds["x"] = Number(bounds["x"]) + step
	    app.windows[0].bounds = bounds
	}

	for(i=0; i<iterations; i++) {
        bounds["x"] = Number(bounds["x"]) - step
	    app.windows[0].bounds = bounds
	}

    app.windows[0].bounds = original_bounds

}

try{

    var system = Application("System Events");
    currentapp = system.processes.whose({frontmost: {"=": true}}).name()
    app = Application(currentapp[0])
    original_bounds = app.windows[0].bounds()

    wiggle();
    wiggle();

} catch (error) {

    app = Application.currentApplication()
    app.includeStandardAdditions = true
    app.setVolume(7)
    app.doShellScript("afplay /System/Library/Sounds/Submarine.aiff")
    app.setVolume(0)

}
