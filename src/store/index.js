import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    web3: null,
    diceContract: null,
    walletAddress: 'CONNECT',
    bscConnect: false,
    tokenBalance: 0.0,
    bnbBalance: 0.0,
    alertMsg: '',
    alert: false,
    walletStatus: 'UNLOCK WALLET',
    swapStatus: 'UNLOCK WALLET',
    poolStatus: 'UNLOCK WALLET',
    farmStatus: 'UNLOCK WALLET',
    viewStatus: 'Unlock View On FMT'
  },

  getters: {
    appState: state => state,
    tokenBalance: state => state.tokenBalance,
    bnbBalance: state => state.bnbBalance,
    alertMsg: state => state.alertMsg,
    alert: state => state.alert,
    walletStatus: state => state.walletStatus,
    swapStatus: state => state.swapStatus,
    poolStatus: state => state.poolStatus,
    farmStatus: state => state.farmStatus,
    viewStatus: state => state.viewStatus
  },

  mutations: {
    chageState(state, appState) {
      if (appState.web3)
        state.web3 = appState.web3

        console.log(appState, state)
      if (appState.walletAddress) {
        state.walletAddress = appState.walletAddress
        if (appState.walletAddress !== 'CONNECT') {
          state.walletStatus = 'WALLET'
          state.viewStatus = 'VIEW ON FMTSCAN'
          state.swapStatus = 'SWAP'
          state.poolStatus = 'ADD LIQUIDITY'
          state.farmStatus = 'FARMING'
        } else {
          state.walletStatus = 'UNLOCK WALLET'
          state.viewStatus = 'UNLOCK VIEW ON FMTSCAN'
          state.swapStatus = 'UNLOCK WALLET'
          state.poolStatus = 'UNLOCK WALLET'
          state.farmStatus = 'UNLOCK WALLET'
        }
      }

      if (appState.bscConnect)
      state.bscConnect = appState.bscConnect

      if (appState.diceContract)
      state.diceContract = appState.diceContract

      if (appState.alertMsg !== "" && appState.alertMsg) {
        state.alertMsg = appState.alertMsg
        state.alert = true
      } else if (appState.alert === false) {
        state.alert = false
      }
    },

    getBalance(state) {
      if (state.walletAddress !== "CONNECT") {
        state.diceContract.methods.balanceOf(state.walletAddress).call(
        ).then((res) => {
          state.tokenBalance = res / 100000000 //decimal is 8
        }).catch(() => {
          state.tokenBalance = 0
        })

        state.web3.eth.getBalance(state.walletAddress).then((res) => {
          state.bnbBalance = res / 1000000000000000000 //decimal is 18
          
        }).catch(() => {
          state.bnbBalance = 0
        })
      } else {
        state.tokenBalance = 0
        state.bnbBalance = 0
      }
    }
  }
});