<template>
    <div>
        <v-card color="background" flat :class="$vuetify.theme.isDark ? 'rounded-0 pa-3' : 'rounded-0 pa-3 bgm'">
            <v-card-title class="text-sm-h5  text-xs-h6 font-weight-bold secondary--text">Learn how to play, farm DICE and how to get player rewards 
            </v-card-title>
            <v-card-text>
                <div>Powered by the fastest blockchain Fantom</div>
            </v-card-text>
        </v-card>
        <v-container>
            <div class="items">
                <div class="items__item">
                    <v-card class="rounded-xl card pa-5" color="background"  outlined>
                        <v-card-title>HOW TO PLAY</v-card-title>
                        <v-card-text>
                            We are preparing a detailed video explaining how to play. Will be uploaded soon.
                        </v-card-text>
                        <v-list-item>
                            <v-btn rounded color="#01659c" elevation="0" block
                            >CLICK HERE
                            </v-btn>
                        </v-list-item>
                    </v-card>
                </div>
                <div class="items__item">
                    <v-card class="rounded-xl card pa-5" color="background" outlined>
                      <v-card-title>How to add liquidity?</v-card-title>
                        <v-card-text>
                            Adding soon..
                        </v-card-text>
                        <v-list-item>
                            <v-btn rounded color="#01659c" elevation="0" block
                            >CLICK HERE
                            </v-btn>
                        </v-list-item>
                    </v-card>
                </div>
            </div>
            <div class="items">
                <div class="items__item">
                    <v-card class="rounded-xl card pa-5" color="background"  outlined>
                      <v-card-title>How to Farm DICE?</v-card-title>
                        <v-card-text>
                            Adding soon..
                        </v-card-text>
                        <v-list-item>
                            <v-btn rounded color="#01659c" elevation="0" block
                            >CLICK HERE
                            </v-btn>
                        </v-list-item>
                    </v-card>
                </div>
                <div class="items__item">
                    <v-card class="rounded-xl card pa-5" color="background" outlined>
                      <v-card-title>How to get DICE for playing</v-card-title>
                        <v-card-text>
                            Adding soon...
                        </v-card-text>
                        <v-list-item>
                            <v-btn rounded color="#01659c" elevation="0" block
                            >CLICK HERE
                            </v-btn>
                        </v-list-item>
                    </v-card>
                </div>
            </div>
        </v-container>
    </div>
</template>

<script>
    import {CUSTOM_NETWORK} from "../../config";

    export default {
        data() {
            return {};
        },
        methods: {
            async unlockWallet() {
                if (typeof window.ethereum === "undefined") {
                    return;
                }

                window.ethereum.request({
                    method: "eth_requestAccounts",
                });
            },
        },
    };
</script>

<style scoped>
    .card {
        position: relative;
        height: 100%;
    }

    .bg {
        position: absolute;
        top: 70px;
        right: 30px;
        opacity: 0.4;
    }

    .items {
        display: flex;
        justify-content: center;
    }

    .items__item {
        max-width: 400px;
        width: 100%;
        margin: 20px;
    }

    @media (max-width: 900px) {
        .card {
            position: relative;
            height: 100%;
        }

        .items {
            display: flex;
            justify-content: center;
            flex-direction: column;
        }

        .items__item {
            max-width: 90%;
        }
    }
</style>