(function () {

    /**
     * Gets the current UTC timestamp as a float
     */
    function getCurrentTime()
    {
        return new Date().getTime() / 1000;
    }

    /**
     * Updates all currently running timers on the page
     */
    function updateTimers($timers, startTime)
    {
        var now = getCurrentTime(),
            offset = now - startTime;

        $timers.each(function () {
            var $this = $(this),
                originalTime = parseFloat($this.data('original-time')),
                newTime = originalTime + offset;

            $this.text(newTime.toFixed(2));
        });
    }

    /**
     * Calls updateTimers() every animation frame
     */
    function updateTimersLoop($timers, startTime) {
        updateTimers($timers, startTime);
        window.requestAnimationFrame(function () {
            updateTimersLoop($timers, startTime);
        });
    }

    /**
     * Stores the start time of each timer
     */
    function setupTimers($timers)
    {
        $timers.each(function () {
            var $this = $(this);
            $this.data('original-time', $this.text());
        });
    }


    var startTime = getCurrentTime(),  // timestamp when the page was loaded
        $timers = $('.timer.running'); // all currently-running timers

    setupTimers($timers);
    updateTimersLoop($timers, startTime);
})();
