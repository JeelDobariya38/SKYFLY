package com.skyfly.util;

import java.util.Locale;
import org.springframework.core.env.Environment;

/**
 * Prints the application URL once the embedded server is up and (optionally)
 * opens it in the default browser. Used when the app is started from
 * NetBeans / "mvn spring-boot:run" / "java -jar".
 *
 * Set  skyfly.open-browser=false  in application.properties (or pass
 * -Dskyfly.open-browser=false) to only print the URL.
 */
public final class BrowserLauncher {

    private BrowserLauncher() {
    }

    public static void announce(Environment env) {
        String port = env.getProperty("local.server.port", env.getProperty("server.port", "8080"));
        String contextPath = env.getProperty("server.servlet.context-path", "");
        if (contextPath.endsWith("/")) {
            contextPath = contextPath.substring(0, contextPath.length() - 1);
        }
        String url = "http://localhost:" + port + contextPath + "/";

        String line = "=".repeat(64);
        System.out.println();
        System.out.println(line);
        System.out.println("  SkyFly Airlines is running!");
        System.out.println();
        System.out.println("  Open in browser : " + url);
        System.out.println("  Admin dashboard : " + url + "admin/dashboard");
        System.out.println("  Servlet health  : " + url + "servlet/health");
        System.out.println(line);
        System.out.println();

        boolean openBrowser = Boolean.parseBoolean(env.getProperty("skyfly.open-browser", "true"));
        if (openBrowser) {
            open(url);
        }
    }

    private static void open(String url) {
        String os = System.getProperty("os.name", "").toLowerCase(Locale.ROOT);
        try {
            ProcessBuilder pb;
            if (os.contains("win")) {
                pb = new ProcessBuilder("rundll32", "url.dll,FileProtocolHandler", url);
            } else if (os.contains("mac")) {
                pb = new ProcessBuilder("open", url);
            } else {
                pb = new ProcessBuilder("xdg-open", url);
            }
            pb.start();
        } catch (Exception e) {
            System.out.println("  (Could not open the browser automatically - please open the URL above.)");
        }
    }
}
