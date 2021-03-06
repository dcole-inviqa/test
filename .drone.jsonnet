local Harness(platform, mode) = {

    kind: "pipeline",
    type: "digitalocean",
    name: platform + " (" + mode + ")",
    token: { from_secret: "token" },

    server: {
        image:  "docker-18-04",
        size:   "s-4vcpu-8gb",
        region: "lon1"
    },

    steps: [
    {
        name: "dependencies",
        commands: [
            "apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install php-cli",
            "wget https://github.com/my127/workspace/releases/download/0.1.3/ws && chmod +x ws && mv ws /usr/local/bin/ws",
        ]
    },
    {
        name: "build",
        commands: [
            "./build"
        ],
    },
    {
        name: "test",
        environment: { 
            MY127WS_KEY: { from_secret: "my127ws-key" },
        },
        commands: [
            "./test " + platform + " " + mode
        ],
    },
  ]
};

[
    Harness("akeneo", "dynamic"),
    Harness("akeneo", "static"),

    Harness("drupal8", "dynamic"),
    Harness("drupal8", "static"),

    Harness("magento1", "dynamic"),
    Harness("magento1", "static"),

    Harness("magento2", "dynamic"),
    Harness("magento2", "static"),

    Harness("spryker", "dynamic"),
    Harness("spryker", "static"),

    Harness("wordpress", "dynamic"),
    Harness("wordpress", "static"),
]
