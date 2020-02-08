
function register() {
    if ("serviceWorker" in navigator) {
        window.addEventListener("load", () => {
            navigator.serviceWorker.register(SERVICE_WORKER_FILE).then((registration) => {
                console.log("SW registered: ", registration);
            }).catch((registrationError) => {
                console.log("SW registration failed: ", registrationError);
            });
        });
    }
}
export default {
    register,
};
