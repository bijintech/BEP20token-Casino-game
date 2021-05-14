<template>
    <div>
        <v-card
                color="background"
                flat
                :class="$vuetify.theme.isDark ? 'rounded-0 pa-3' : 'rounded-0 pa-3 bgm'"
        >
            <v-card-title
                    class="text-sm-h5 text-xs-h6 font-weight-bold secondary--text"
            >SWAP FTM to DICE to Play and Farm
            </v-card-title>
            <v-card-text>
                <div>Powered by the fastest blockchain Fantom</div>
            </v-card-text>
        </v-card>
        <div class="items">
            <div class="items__item">
                <div v-html="swapAlert"></div>
                <v-card class="rounded-xl card" color="background" outlined>
                    <v-app-bar flat color="rgba(0, 0, 0, 0)">
                        <v-toolbar-title class="title white--text pl-0">
                            <v-card-title class="pa-0">Exchange</v-card-title>
                            <v-card-title class="secondary--text pa-0 text-subtitle-2"
                            >Trade FTM instantly to get DICE
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
                            <div
                                    class="px-3 py-2 rounded-lg"
                                    style="width: 100%; background-color: #dddddd20"
                            >
                                <div class="d-flex justify-space-between">
                                    <div>From</div>
                                    <div>Balance: 000.00</div>
                                </div>
                                <div style="display: flex; justify-content: space-between">
                  <span class="form-control"
                  ><input
                          class="form-control"
                          id="ex1"
                          type="number"
                          Placeholder="0.0"
                          v-model="inputAmount"
                          @keyup="keyUpEvent('from')"
                  /></span>
                                    <div class="d-flex align-center"
                                    >
                                        <v-btn text small color="secondary">Max</v-btn>
                                        <v-img
                                                v-if="swapMode === 0"
                                                width="25"
                                                height="25"
                                                contain
                                                class="mr-2"
                                                :src="require('../assets/fantom-ftm.png')"
                                        />
                                        <v-img
                                                v-if="swapMode === 1"
                                                width="25"
                                                class="mr-2"
                                                :src="require('../assets/DICE-COIN.png')"
                                        />
                                        {{ inToken }}
                                    </div
                                    >
                                </div>
                            </div>
                        </v-list-item>

                        <v-list-item
                                style="width: 100%; display: flex; justify-content: center"
                                class="my-2"
                        >
                            <v-btn icon @click="reverse()">
                                <v-icon>mdi-arrow-down</v-icon>
                            </v-btn>
                        </v-list-item>
                        <v-list-item style="width: 100%" class="my-2">
                            <div
                                    class="px-3 py-2 rounded-lg"
                                    style="width: 100%; background-color: #dddddd20"
                            >
                                <div class="d-flex justify-space-between">
                                    <div>To</div>
                                    <div>Balance: 000.00</div>
                                </div>
                                <div style="display: flex; justify-content: space-between">
                  <span class="form-control"
                  ><input
                          class="form-control"
                          id="ex2"
                          type="number"
                          Placeholder="0.0"
                          v-model="outputAmount"
                          @keyup="keyUpEvent('to')"
                  /></span>
                                     <div class="d-flex align-center"
                                    >
                                        <v-btn text small color="secondary">Max</v-btn><v-img
                                            v-if="swapMode === 0"
                                            width="25"
                                            class="mr-2"
                                            :src="require('../assets/DICE-COIN.png')"
                                    /><v-img
                                            v-if="swapMode === 1"
                                            width="25"
                                            class="mr-2"
                                            :src="require('../assets/fantom-ftm.png')"
                                    />
                                         {{ outToken }}</div>
                                </div>
                            </div>
                        </v-list-item>
                        <v-list-item
                                style="width: 100%; display: flex; justify-content: center"
                                class="my-2"
                        >
                            <div
                                    style="
                  display: flex;
                  justify-content: space-between;
                  width: 100%;
                "
                            >
                                <span>Slippage Tolerance</span>
                                <span>1%</span>
                            </div>
                        </v-list-item>
                        <v-list-item
                                style="width: 100%; display: flex; justify-content: center"
                                class="my-2"
                        >
                            <v-btn
                                    rounded
                                    color="#01659c"
                                    elevation="0"
                                    block
                                    @click="unlockWallet()"
                            >{{swapStatus}}
                            </v-btn>
                        </v-list-item>
                    </v-list>
                    <v-expansion-panels flat class="my-5">
                        <v-expansion-panel class="transparent">
                            <v-expansion-panel-header>Detail</v-expansion-panel-header>
                            <v-expansion-panel-content>
                                <div class="d-flex justify-space-between">
                                    <div>Trading Price:</div>
                                    <div>100 DICE = 1 FTM</div>
                                </div>
                                <div class="d-flex justify-space-between">
                                    <div>Total Liquidity:</div>
                                    <div>$000,000,000</div>
                                </div>
                                <div class="d-flex justify-space-between">
                                    <div>Price:</div>
                                    <div>$0</div>
                                </div>
                            </v-expansion-panel-content>
                        </v-expansion-panel>
                    </v-expansion-panels>
                </v-card>
            </div>
        </div>
        <v-dialog v-model="dialog" width="500">
            <v-card class="rounded-xl card" color="background" flat>
                <v-app-bar flat color="rgba(0, 0, 0, 0)">
                    <v-toolbar-title class="title white--text pl-0">
                        Alert
                    </v-toolbar-title>
                    <v-spacer></v-spacer>
                    <v-btn icon @click="dialog = false">
                        <v-icon>mdi-close</v-icon>
                    </v-btn>
                </v-app-bar>
                <v-card-text>
                    {{ alertMsg }}
                </v-card-text>
            </v-card>
        </v-dialog>
    </div>
</template>

<script>
    import {mapGetters, mapMutations} from "vuex";
    import {CUSTOM_NETWORK} from "../../config";

    export default {
        name: "Swap",

        data() {
            return {
                from: {id: 1, name: "user1"},
                to: {id: 1, name: "user2"},
                dialog: false,
                alertMsg: "",
                diceContract: null,
                swapMode: 0,
                inToken: "FMT",
                outToken: "DICE",
                inputAmount: 0.0,
                outputAmount: 0.0,
                bnbReserve: -1,
                diceReserve: -1,
                case: 0,
                swapAlert: "",
            };
        },

        computed: {
            ...mapGetters({
                appState: "appState",
                tokenBalance: "tokenBalance",
                bnbBalance: "bnbBalance",
                swapStatus: 'swapStatus',
                viewStatus: 'viewStatus'
            }),
        },

        mounted() {
            this.diceContract = this.appState.diceContract;
            this.getReserves();
        },

        methods: {
            ...mapMutations(["callTokenBalance", "getBalance"]),

            getReserves() {
                if (this.diceContract)
                    this.diceContract.methods
                        .getReserves()
                        .call()
                        .then((res) => {
                            this.bnbReserve = Number(res.amountA) / Math.pow(10, 18);
                            this.diceReserve = Number(res.amountB) / Math.pow(10, 8);
                        });
            },

            swap() {
                this.swapAlert = "";
                if (this.appState.walletAddress === "CONNECT") {
                    //this.alertMessage("please connect wallet");
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>please connect wallet</div>";
                    return;
                }

                this.inputAmount = Number(this.inputAmount);
                this.outputAmount = Number(this.outputAmount);

                if (this.inputAmount === 0 || this.outputAmount === 0) {
                    //this.alertMessage("input or output can't be 0!!!!");
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Thinking about selecting some FTM or DICE</div>";
                    return;
                }

                this.inputAmount = this.inputAmount.toFixed(this.swapMode === 0 ? 4 : 0);
                this.outputAmount = this.outputAmount.toFixed(
                    this.swapMode === 0 ? 0 : 4
                );

                if (this.bnbReserve < 0 || this.diceReserve < 0) {
                    this.inputAmount = 0;
                    this.outputAmount = 0;
                    //this.alertMessage("reserve received not yet from net");
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>FTM Reserve has not received yet</div>";
                    return;
                }

                if (this.swapMode === 0 && this.inputAmount > this.bnbBalance) {
                    //this.alertMessage("insufficient fmt for swap");
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Insufficient FTM balance to swap</div>";
                    return;
                }

                if (this.swapMode === 1 && this.inputAmount > this.tokenBalance) {
                    //this.alertMessage("insufficient token for swap");
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Insufficient DICE balance to swap</div>";
                    return;
                }

                if (this.outputAmount > this.diceReserve && this.swapMode === 0) {
                    /*this.alertMessage(
                      "dice amounts you wanna swap are more than dices in liquidity pool"
                    );*/
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>DICE amount is more than the DICE in liquidity pool</div>";
                    return;
                }

                if (this.outputAmount > this.bnbReserve && this.swapMode === 1) {
                    /*this.alertMessage(
                      "fmt amounts you wanna swap are more than fmts in liquidity pool"
                    );*/
                    this.swapAlert = "";
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>FTM amount is more than the FTM in liquidity pool</div>";
                    return;
                }

                if (this.inputAmount > this.bnbReserve && this.swapMode === 0) {
                    /*this.alertMessage(
                      "fmt amounts you selected are more than fmts in liquidity pool"
                    );*/
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>FTM amount is more than the FTM in liquidity pool</div>";
                    return;
                }

                if (this.inputAmount > this.diceReserve && this.swapMode === 1) {
                    /*this.alertMessage(
                      "dice amounts you selected are more than dices in liquidity pool"
                    );*/
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>DICE amount is more than the DICE in liquidity pool</div>";
                    return;
                }

                if (this.swapMode === 0) {
                    this.diceContract.methods
                        .swapExactETHForTokens(this.appState.walletAddress)
                        .send({
                            from: this.appState.walletAddress,
                            value: Math.pow(10, 18) * this.inputAmount,
                        })
                        .then(() => {
                            this.getBalance();
                            this.getReserves();
                        });
                } else if (this.swapMode === 1) {
                    this.diceContract.methods
                        .swapExactTokensForETH(
                            this.inputAmount * Math.pow(10, 8),
                            this.appState.walletAddress
                        )
                        .send({from: this.appState.walletAddress})
                        .then(() => {
                            this.getBalance();
                            this.getReserves();
                        });
                } /* else if (this.case === 2) {
        this.diceContract.methods.swapExactETHForTokens((this.outputAmount * Math.pow(10, 8)), this.appState.walletAddress).send({ from: this.appState.walletAddress, value: Math.pow(10, 18) * this.inputAmount }
        ).then(() => {
          this.getBalance()
          this.getReserves()
        })
      } else {
        this.diceContract.methods.swapExactTokensForETH(this.inputAmount * Math.pow(10, 8), (this.outputAmount * Math.pow(10, 18)).toString(), this.appState.walletAddress).send({ from: this.appState.walletAddress}
        ).then(() => {
          this.getBalance()
          this.getReserves()
        })
      }*/
            },

            reverse() {
                this.inputAmount = "";
                this.outputAmount = "";
                this.swapMode = this.swapMode === 1 ? 0 : 1;
                if (this.swapMode === 1) {
                    this.inToken = "DICE";
                    this.outToken = "FMT";
                } else {
                    this.inToken = "FMT";
                    this.outToken = "DICE";
                }
            },

            keyUpEvent(dir) {
                if (this.appState.walletAddress === "CONNECT") {
                    this.inputAmount = 0;
                    this.outputAmount = 0;
                    //this.alertMessage("connect wallet!!!!");
                    /*this.swapAlert =
                      "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>please connect to wallet</div>";*/
                    return;
                }

                if (this.bnbReserve < 0 || this.diceReserve < 0) {
                    //this.alertMessage("reserve received not yet from net");
                    this.swapAlert =
                        "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Loading...</div>";
                    return;
                }

                if (this.bnbReserve === 0 || this.diceReserve === 0) return;

                if (dir === "from") {
                    this.case = this.swapMode === 0 ? 0 : 1;
                    if (
                        this.inputAmount >
                        (this.swapMode === 0 ? this.bnbBalance : this.tokenBalance)
                    ) {
                        console.log(this.inputAmount, this.bnbBalance, this.tokenBalance);
                        this.inputAmount = 0;
                        this.outputAmount = 0;
                        let str =
                            "insufficient " +
                            (this.swapMode === 0 ? "fmt" : "token") +
                            " balance";
                        //this.alertMessage(str);
                        this.swapAlert =
                            "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>" + str + "</div>";
                        return
                    } else {
                        if (this.inputAmount == 0) return;
                        if (this.swapMode === 0) {
                            this.diceContract.methods
                                .getAmountsOutFromETH(
                                    (Math.pow(10, 18) * this.inputAmount).toString()
                                )
                                .call()
                                .then((res) => {
                                    this.outputAmount = res / 100000000; //.toFixed(3)
                                });
                        } else {
                            this.diceContract.methods
                                .getAmountsOutFromToken((this.inputAmount * 100000000).toString())
                                .call()
                                .then((res) => {
                                    this.outputAmount = res / Math.pow(10, 18); //.toFixed(3)
                                });
                        }
                    }
                } else if (dir === "to") {
                    this.case = this.swapMode === 0 ? 2 : 3;
                    if (
                        this.outputAmount >
                        (this.swapMode === 0 ? this.tokenBalance : this.bnbBalance) ||
                        this.outputAmount == 0
                    ) {
                        this.inputAmount = 0;
                        this.outputAmount = 0;
                        let str =
                            "insufficient " +
                            (this.swapMode === 0 ? "token" : "fmt") +
                            " balance";
                        //this.alertMessage(str);
                        this.swapAlert =
                            "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Please connect to your wallet</div>";
                        return
                    } else {
                        if (this.outputAmount == 0) return;
                        if (this.swapMode === 0) {
                            this.appState.diceContract.methods
                                .getAmountsInFromETH((100000000 * this.outputAmount).toString())
                                .call()
                                .then((res) => {
                                    this.inputAmount = (res / 1000000000000000000).toFixed(3);
                                });
                        } else {
                            this.appState.diceContract.methods
                                .getAmountsInFromToken(
                                    (this.outputAmount * Math.pow(10, 18)).toString()
                                )
                                .call()
                                .then((res) => {
                                    this.inputAmount = (res / Math.pow(10, 18)).toFixed(3);
                                });
                        }
                    }
                }
                this.swapAlert = ""
            },
            alertMessage(msg) {
                this.alertMsg = msg;
                this.dialog = true;
            },
            async unlockWallet() {
                if (typeof window.ethereum === "undefined") {
                    return;
                }

                if (this.appState.walletStatus !== "CONNECT") {
                    this.swap()
                    return
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

    .form-control {
        color: white;
        width: 100%;
    }
</style>