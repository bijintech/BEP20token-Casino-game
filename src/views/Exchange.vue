<template>
    <div>
        <v-card color="background" flat :class="$vuetify.theme.isDark ? 'rounded-0 pa-3' : 'rounded-0 pa-3 bgm'">
            <v-card-title class="text-sm-h5  text-xs-h6 font-weight-bold secondary--text">SWAP FTM to DICE to Play and Farm
            </v-card-title>
            <v-card-text>
                <div>Powered by the fastest blockchain Fantom</div>
            </v-card-text>
        </v-card>
        <div class="items">
            <div class="items__item">
                <v-card class="rounded-xl card" color="background" outlined>
                    <v-app-bar flat color="rgba(0, 0, 0, 0)">
                        <v-toolbar-title class="title white--text pl-0">
                            <v-card-title class="pa-0">Exchange</v-card-title>
                            <v-card-title class="secondary--text pa-0 text-subtitle-2">Trade token in an instant
                            </v-card-title>
                        </v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-btn icon @click="dialog = true">
                            <v-icon>mdi-cog</v-icon>
                        </v-btn>
                        <v-btn icon>
                            <v-icon>mdi-history</v-icon>
                        </v-btn>
                    </v-app-bar>

                    <v-divider></v-divider>
                    <v-list color="transparent" class="my-6">
                        <v-list-item style="width: 100%" class="my-2">
                            <div class="px-3 py-2 rounded-lg" style="width: 100%; background-color: #dddddd20;">
                                <div>Form</div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span>0.0</span>
                                    <span style="display: flex;"><v-img width="25" class="mr-2"
                                                                        :src="require('../assets/DICE-COIN.png')"/> DICE</span>
                                </div>
                            </div>
                        </v-list-item>

                        <v-list-item style="width: 100%; display: flex; justify-content: center;" class="my-2">
                            <v-btn icon>
                                <v-icon>mdi-arrow-down</v-icon>
                            </v-btn>
                        </v-list-item>
                        <v-list-item style="width: 100%" class="my-2">
                            <div class="px-3 py-2 rounded-lg" style="width: 100%; background-color: #dddddd20;">
                                <div>To</div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span>0.0</span>
                                    <span style="display: flex;"><v-img width="25" class="mr-2"
                                                                        :src="require('../assets/DICE-COIN.png')"/> DICE</span>
                                </div>
                            </div>
                        </v-list-item>
                        <v-list-item style="width: 100%; display: flex; justify-content: center;" class="my-2">
                            <div style="display: flex; justify-content: space-between; width: 100%;">
                                <span>Slippage Tolerance</span>
                                <span>1%</span>
                            </div>
                        </v-list-item>
                        <v-list-item style="width: 100%; display: flex; justify-content: center;" class="my-2">
                            <v-btn rounded color="#01659c" elevation="0" block @click="dialog = true">Unlock Wallet
                            </v-btn>
                        </v-list-item>
                    </v-list>
                </v-card>
            </div>
        </div>
        <v-dialog v-model="dialog" width="500">
            <v-card class="rounded-xl card" color="background" flat>
                <v-app-bar flat color="rgba(0, 0, 0, 0)">
                    <v-toolbar-title class="title white--text pl-0">
                        Settings
                    </v-toolbar-title>
                    <v-spacer></v-spacer>
                    <v-btn icon @click="dialog = false">
                        <v-icon>mdi-close</v-icon>
                    </v-btn>
                </v-app-bar>
                <v-card-text>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore
                    et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
                    aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
                    cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
                    culpa qui officia deserunt mollit anim id est laborum.
                </v-card-text>
            </v-card>
        </v-dialog>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                from: {id: 1, name: 'user1'},
                to: {id: 1, name: 'user2'},
                dialog: false
            }
        }

    }
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
        min-width: 50%;
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